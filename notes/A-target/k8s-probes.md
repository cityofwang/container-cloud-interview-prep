# 探针 liveness / readiness / startup

- 维：C1｜题：R1-Q07｜状态：一面不会→补洞中

> 三种探针都是 kubelet **周期性探测容器**；差别在**失败后干什么**，不是「一个管启动一个管存活」那么含糊。

---

## 1. 结论背板

| 探针 | 问的问题 | 失败后果 |
|------|----------|----------|
| **liveness** | 还活着吗？要不要救？ | **重启容器** |
| **readiness** | 能不能接流量？ | **从 Service Endpoints 摘掉**（不重启） |
| **startup** | 慢启动结束了吗？ | 启动期内失败按配置重试；**成功前先挡住** liveness/readiness，避免未就绪就被活探针杀掉 |

**不是 initContainer：**  
init 容器 = 主容器跑之前另起的初始化容器。  
startup = **主容器自己**还在慢慢起来时，用探针保护它。

---

## 2. 机制直觉

```text
容器启动
  │
  ├─ 若有 startup：先只跑 startup，过了再启用 liveness/readiness
  │
  ├─ readiness 失败 → Pod NotReady → 不进/踢出 Endpoints → 无流量
  └─ liveness 失败 → kubelet 杀容器并重启 → 可能 CrashLoop
```

探测方式常见：HTTP GET / TCP Socket / exec 命令。

---

## 3. 对比与误配

| 误配 | 后果 |
|------|------|
| liveness 打到「依赖 DB/下游」的接口 | 依赖抖一下 → **重启风暴** |
| readiness 过松（几乎永成功） | **带病接流量** |
| readiness 过严 / 依赖不稳 | Ready 抖动 → 容量假死、滚动卡住 |
| 没有 startup，慢应用 + 紧 liveness | 还没起来就被活探针杀 → CrashLoop |
| 把 readiness 理解成「进程起没起」 | 漏掉「摘流量」——面试硬伤 |

---

## 4. 和发布的关系（加分一句）

Deployment 滚动常等新 Pod **Ready**（readiness 过）再缩老的。  
readiness 配错 → 滚动卡住或带病上线；liveness 配错 → 新 Pod 反复重启，发布失败。

---

## 5. 自测

1. readiness 失败会不会重启容器？  
2. startup 和 initContainer 差在哪？  
3. 为什么 liveness 不该依赖外部 DB？
