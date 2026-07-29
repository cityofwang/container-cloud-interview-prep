# List-Watch / Informer（机制详解 · L3）

- 维：C1/G3｜题：R1-Q13｜状态：一面不会→补洞中（已加深）

> **面试总句：** 控制器只访问 **apiserver**。用 **List 打底 + Watch 增量** 维持本地视图；**Informer** 把这套封装成「本地缓存 + 事件回调 + 队列」。etcd 是 apiserver 内部存储，客户端不直连。

---

## 0. 角色关系（先钉死）

```text
┌─────────────┐     HTTPS List/Watch      ┌────────────┐     读写      ┌──────┐
│ 控制器/工具  │  ─────────────────────►  │ apiserver  │  ─────────►  │ etcd │
│ (client-go) │  ◄─── 对象流/事件流 ────  │ 鉴权·校验  │  ◄─────────  │ 持久化│
└─────────────┘                           └────────────┘              └──────┘
```

| 组件 | 干什么 |
|------|--------|
| **etcd** | 存集群期望/状态的权威数据 |
| **apiserver** | 唯一对外 API：鉴权、准入、校验、版本、提供 List/Watch |
| **控制器** | 调谐：看现状 vs 期望，写回对象或调节点组件 |

**为何不让控制器直连 etcd？**  
鉴权/Schema/准入Webhook/多版本 API 都在 apiserver；直连会绕过控制面，也不利于限流与审计。

---

## 1. List-Watch 是什么问题

控制器需要「集群里某某资源现在长什么样，以及之后怎么变」。

| 方案 | 做法 | 问题 |
|------|------|------|
| 裸轮询 | 每隔 N 秒 List 一次 | 延迟大、压 apiserver、费带宽 |
| 只 Watch | 挂长连接听变化 | **没有可靠起点**；断线不知漏了啥 |
| **List-Watch** | 先 List 全量，再从某版本 Watch | 有全集 + 近实时增量 |

这就是 K8s 控制面与绝大多数控制器的标准感知模型。

---

## 2. List：全量打底

### 2.1 调用形态（概念）

```http
GET /api/v1/pods?limit=500
# 或带 labelSelector / fieldSelector
```

返回：

- 当前匹配到的对象列表  
- 列表级的 **`resourceVersion`（RV）**：表示「这次快照对应到存储的哪个版本点」

### 2.2 关键逻辑

1. 客户端把列表写入**本地缓存**（map：namespace/name → 对象）  
2. 记下本次 List 返回的 **RV**，作为后续 Watch 的起点  
3. 大集群常 **分页 List**（continue token），拼成逻辑全量后再 Watch  

List 解决的是：**我现在相信的世界长什么样。**

---

## 3. Watch：增量流

### 3.1 调用形态（概念）

```http
GET /api/v1/pods?watch=1&resourceVersion=<上次的RV>
```

这是**长连接**：apiserver 持续推送事件，而不是一次请求立刻结束。

### 3.2 事件类型（直觉）

| 类型 | 含义 |
|------|------|
| ADDED | 新对象出现（或对你来说第一次看到） |
| MODIFIED | 同一对象变更 |
| DELETED | 对象删除 |
| BOOKMARK / ERROR | 书签进度 / 错误（实现细节，面试点到「还有进度与错误事件」即可） |

每条事件通常仍带着对象（或删除前的对象）以及新的 RV。客户端用事件**更新本地缓存**，并推进「我已看到的 RV」。

### 3.3 apiserver 侧在干什么（配合关系）

概念链（不必背源码函数名）：

1. 有客户端挂 Watch（带起始 RV）  
2. 某处写入导致 etcd/存储版本前进（创建 Pod、改 status…）  
3. apiserver 把**从该 RV 之后**的变化，编码成 Watch 事件推给订阅者  
4. 多客户端 Watch 同一资源 = 扇出；所以 Watch 连接数、selector 范围都影响控制面压力  

**resourceVersion 干什么？**  
单调进度标记：「从世界的哪个版本之后开始听」。续 Watch、判断是否过期，都靠它。

---

## 4. 断线与重建（关键逻辑）

Watch 是长连接，必然断：网络抖、apiserver 滚动、空闲超时、对端限流等。

### 标准策略

```text
Watch 出错/断开
    │
    ├─ 1) 退避（backoff）避免打爆
    ├─ 2) 用「我记下的最后一个 RV」再 Watch
    │       成功 → 继续增量
    │       失败（RV 过期/太旧/Gone 一类）
    └─ 3) 再 List 全量 → 重建本地缓存 → 用新 RV 再 Watch
```

**为何 RV 会过期？**  
apiserver/etcd 不会无限保留历史事件窗口；断太久，从旧 RV 续 Watch 可能被拒绝 → **必须全量 List 重建**。

**为何 handler 要幂等？**  
重建、重连、重复 MODIFIED 都会让你「再处理一次」同一逻辑对象；调谐应按期望收敛，而不是「事件来一次就副作用一次」。

---

## 5. 为什么必须 List + Watch（合在一起）

| 只有 List | 只有 Watch |
|-----------|------------|
| 有全集，但不近实时 | 近实时，但无可靠全集 |
| 要高频轮询才追得上 | 启动瞬间与断线空洞无法自证 |

合在一起：List 给一致起点，Watch 给增量，断线用 RV 续或 List 重建。

---

## 6. Informer：把 List-Watch 产品化

裸写 List+Watch 也能工作，但每个控制器都要重复：缓存、重连、去重、线程安全、反压。  
**client-go SharedInformer**（口语「Informer」）就是这套标准封装。

### 6.1 一张总图

```text
                    ┌──────────────────────────────────────────┐
                    │              SharedInformer              │
   apiserver  ◄──►  │  Reflector: 真正做 List-Watch + 重连     │
                    │       │                                  │
                    │       ▼                                  │
                    │  DeltaFIFO: 事件排队（增删改差分）         │
                    │       │                                  │
                    │       ▼                                  │
                    │  Indexer/Store: 本地缓存（可按索引查）     │
                    │       │                                  │
                    │       ▼                                  │
                    │  分发给已注册的 ResourceEventHandler      │
                    │    OnAdd / OnUpdate / OnDelete           │
                    └──────────────────────────────────────────┘
                                      │
                                      ▼ 常再进
                               WorkQueue（限速/重试）
                                      │
                                      ▼
                               你的 Reconcile（调谐）
```

### 6.2 各块职责

| 块 | 作用 |
|----|------|
| **Reflector** | 对某种资源跑 List-Watch；维护 RV；断线重连/全量重建 |
| **DeltaFIFO** | 把对象变化收成队列项；合并同一 key 的多个 delta，避免 handler 跟风暴硬刚 |
| **Store/Indexer** | 本地只读视图；业务逻辑优先 `Get/List` 本地，**少打 apiserver** |
| **Handler** | 缓存变更时回调；通常只做「把 key 丢进 WorkQueue」，重活放调谐循环 |
| **WorkQueue** | 限速、延迟重试、忘记/重入控制；一个 reconcile 卡住不应无限拖死全部（点到解耦即可） |

### 6.3 SharedInformer 的「Shared」

同进程多个控制器关心 Pod → **共用一个 Pod Informer**：  
一条 List-Watch 连接，多份 handler。降低对 apiserver 的连接数与重复 List。

### 6.4 和「每次 API 读」对比

| | 每次 get/list apiserver | Informer 本地缓存 |
|--|-------------------------|-------------------|
| 延迟 | 网络 RTT | 内存级 |
| 压力 | 高 | 读路径几乎不压 apiserver |
| 一致性 | 较强（直读） | **最终一致**（有同步窗口）；写路径仍要走 apiserver |

控制器模式：读多走缓存，写走 apiserver；调谐循环发现偏差再更新。

---

## 7. 和运维自动化的关系（挂钩你的经历）

你若自己 Watch Event 做处置：

- 同构：也是「跟 apiserver Watch」，不是跟 etcd  
- 必须 **限流/去重/幂等**（事件风暴）  
- 你是**反应式运维**，不是替换 controller-manager；别把自己写成第二个控制面硬刚  

Informer 适合长驻控制器；一次性脚本有时 List 就够，不必硬上 Informer。

---

## 8. 口述分层（面试用）

**L3 必会（约 40 秒）：**  
客户端经 apiserver：List 打底 + Watch 增量；断线用 RV 续，续不上再 List；Informer = 这套 + 本地缓存 + 队列回调；不直连 etcd。

**加分（再 20 秒）：**  
SharedInformer 共用连接；读缓存写 API；handler 幂等 + WorkQueue 限速。

**不必默写：** Reflector 类名每一行源码、etcd MVCC 细节（偏 L4）。

---

## 9. 自测

1. List 返回的 RV 后面干什么用？  
2. Watch RV 过期时为什么要重新 List？  
3. Informer 里「读本地 / 写 apiserver」各解决什么？  
4. DeltaFIFO / WorkQueue 存在的理由（各一句）？
