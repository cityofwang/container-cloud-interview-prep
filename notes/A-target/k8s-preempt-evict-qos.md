# 抢占 · 驱逐 · QoS（易混三件套）

- 维：C1｜题：R1-Q24｜挂钩：Q06、Q23、FZ5 混部｜题源：2026-08-05 面经/调度 JD

> 总句：**QoS 描述 Pod 资源档位；抢占是调度器为高优 Pod 腾节点；驱逐是 kubelet 在节点压力下踢 Pod。** 三者都能「让 Pod 消失/让位」，但决策者和时机不同。

---

## 1. 对比表（必背）

| | QoS | 调度抢占 Preemption | kubelet 驱逐 Eviction |
|--|-----|---------------------|------------------------|
| **谁决定** | 由 requests/limits **推导** | **kube-scheduler** | **kubelet**（节点本地） |
| **何时** | 创建时定档；影响驱逐顺序等 | 高优 Pod **调度不上**时 | 节点 **内存/磁盘压力**等 |
| **干什么** | Guaranteed / Burstable / BestEffort | 可能删低优 Pod 给高优让路 | 按信号杀/驱逐 Pod 保节点 |
| **常见误会** | 当成「优先级数字」 | 当成 OOM | 当成调度器干的 |

优先级（PriorityClass）常和**抢占**一起讲；QoS **不是** PriorityClass。

---

## 2. 和混部的关系（一句）

在离线混部常组合：池化污点 / 优先级与抢占 / QoS+cgroup 水位。  
面试先分清三件套，再挂你的真实手段，不编 Koordinator 源码。

---

## 3. 30 秒背板

> QoS 看 requests/limits 档位；抢占是调度器为高优先级腾地方；驱逐是 kubelet 看节点压力。排障先问：是 Pending 调度失败，还是 Running 节点告警后被踢。

自测：Pod 一直 Pending 显示 unschedulable，更可能先查抢占/资源/污点，还是查驱逐？
