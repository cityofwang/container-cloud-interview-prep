# 控制面组件职责与边界

- 维：C1｜题：R1-Q16｜状态：一面不会→补洞中（已加深）

> 四件套各一句话 + **托管边界诚实**。忌把 etcd 说成「缓存」。

---

## 0. 推荐口述（约 60～90 秒，可背骨架）

> Kubernetes 控制面大致四块：  
> **kube-apiserver** 是集群的 **API 唯一入口**：所有 kubectl、控制器、云组件对对象的读写都走它，负责鉴权、校验、准入，再把状态落到存储。  
> **etcd** 是集群状态的 **持久化权威存储**，不是缓存；Pod/Service/Deployment 等对象的期望与状态最终落在这里。  
> **kube-scheduler** 负责给还没绑定节点的 Pod **选节点并完成绑定**，按资源、亲和、污点容忍等过滤打分。  
> **kube-controller-manager** 里跑着多种控制器，持续 **调谐**：让实际状态靠近你在 API 里声明的期望，比如 Deployment 副本、Endpoints、PV 绑定等。  
>  
> 我这边主要是 **托管集群**：日常很少直接运维 etcd；排障更看事件、控制面可用性、apiserver 指标和组件日志。控制面挂了时，**已经在跑的业务 Pod 通常还能跑**，但创建、扩容、改对象、新调度会受影响。源码级 Raft/调度插件细节我按岗位需要补，一面先把职责和边界说清。

---

## 1. 一句话职责（精简版）

| 组件 | 一句话 |
|------|--------|
| **apiserver** | 集群 **API 唯一入口**：鉴权、校验、准入；对象读写经它进存储 |
| **etcd** | 集群状态的 **持久化权威存储**（不是缓存） |
| **scheduler** | 给未绑定 Pod **选节点并写入绑定**（过滤+打分等） |
| **controller-manager** | 一堆控制器：**调谐**期望状态 vs 实际状态（Deployment/Endpoint/PV…） |

**别说「apiserver 是大脑」当主定义**——面试官更爱听「唯一 API 入口」。调度/调谐也有「决策」，大脑比喻易糊。

---

## 2. 配合关系（怎么串）

```text
你/CI/控制器
      │  create/update/watch
      ▼
 kube-apiserver  ──持久化──►  etcd
      ▲
      │ List-Watch / 写回 status、绑定等
      │
 ┌────┴─────────────────────────┐
 │ scheduler：绑定 nodeName      │
 │ controllers：调谐副本/EP/PV…  │
 └──────────────────────────────┘
           │
           ▼  间接影响
      kubelet（节点数据面）拉起容器
```

- **写期望**：你提交 Deployment → apiserver 校验 → 写入 etcd  
- **调谐**：Deployment controller Watch 到变化 → 创建/删 Pod 对象（仍经 apiserver）  
- **调度**：新 Pod 无节点 → scheduler 选节点 → 写 binding  
- **落地**：kubelet Watch 到绑定到自己的 Pod → 拉镜像跑容器  

---

## 3. 各组件再展开一层（面试加分，勿变源码背诵）

### apiserver
- 唯一 HTTP/HTTPS API 面；RBAC、认证、Admission  
- 不负责「选哪台机器」或「副本不够就造」——那是 scheduler / controller  

### etcd
- 持久化、可共识的存储；控制面高可用常谈 etcd 成员与延迟  
- **≠ 缓存**：Informer 本地 store 才是读路径缓存  

### scheduler
- 输入：Pending 且未绑定的 Pod  
- 输出：绑定到某 Node（过滤不可调度 → 打分选优）  
- 不管容器怎么跑，那是 kubelet  

### controller-manager
- 多个 control loop：观察 → 对比期望/实际 → 行动（仍调 apiserver）  
- 例：Deployment、ReplicaSet、Endpoint、PV/PVC、Job…  
- 和 scheduler 对比：**持续调谐** vs **绑定这一次决策**  

---

## 4. 硬伤纠正

| 错觉 | 正解 |
|------|------|
| etcd 是 apiserver 的后端**缓存** | etcd 是 **持久化存储**；挂了控制面写不进去。缓存更像 Informer 本地 store |
| 控制器直接改 etcd | 经 **apiserver** |
| 控制面挂了业务全停 | 已在跑的 Pod **通常继续跑**；不能创建/变更/调度新绑定 |
| apiserver = 大脑（唯一说法） | 优先说 **API 唯一入口**；「大脑」当修辞可以，别当定义 |

---

## 5. 边界怎么答（托管运维向）

1. 日常排障看：事件、组件是否 Ready、控制面可用性指标、apiserver 延迟/错误率  
2. **少直接运维 etcd**（尤其托管 ACK/EKS）：证书、备份、成员变更多为云厂商职责  
3. 不懂源码时：说清职责分工 + 「我怎么验证/查哪类信号」+ 学习路径；**不装懂 Raft 细节**（加分另说）

---

## 6. 对比点

- 控制面故障 vs 数据面：存量 Pod 可跑；变更停摆  
- apiserver vs etcd：入口 vs 存储  
- scheduler vs controller：绑节点一次决策 vs 持续调谐  

---

## 7. 自测

1. 为什么不能说 etcd 是缓存？  
2. 控制面挂了，已有业务 Pod 还跑吗？还能扩容吗？  
3. controller-manager 和 apiserver 各解决什么问题？
