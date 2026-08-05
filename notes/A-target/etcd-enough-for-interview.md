# etcd 面试够用级（非 Raft 精读）

- 维：C1｜挂钩：R1-Q16、脉脉调度研发 JD（K8s+Etcd 原理）
- 深度：知定位与压力现象；Raft/脑裂源码级仍可后置

> 总句：**etcd 是 K8s 的集群状态仓库；apiserver 是唯一建议的读写入口。** 调度器、控制器都是通过 apiserver（List-Watch）间接依赖 etcd。

---

## 1. 在架构里的位置

```text
kubectl / 控制器 / kube-scheduler / kubelet（状态上报）
        ↓
   kube-apiserver
        ↓
      etcd（持久化集群状态）
```

| 谁 | 和 etcd |
|----|---------|
| apiserver | 直接读写 etcd |
| scheduler | **不**直接连 etcd；Watch Pod/Node |
| 业务 Pod | 不直接碰 etcd |

---

## 2. 面试常问（够用答）

| 问 | 答要点 |
|----|--------|
| etcd 存什么 | 集群期望与部分状态（各类 API 对象） |
| 为何要 HA | 控制面可用性；奇数节点、备份 |
| 慢/抖时现象 | apiserver 延迟高、控制器/调度变慢、雪崩感 |
| 和 List-Watch | Watch 的是 apiserver；背后是 etcd 变更 |
| Watch / 租约直觉 | 客户端经 apiserver Watch 变更流；lease/TTL 常用于临时键与保活（面经点到即可） |
| 一致性一句 | 多节点 etcd 用共识保证同一 key 的线性读体验；细节 Raft 后置 |

**不必先背：** Raft 投票细节、boltdb 页结构、脑裂手工恢复步骤（加分后置）。

---

## 3. 30 秒背板

> etcd 存 K8s 状态，经 apiserver 访问。调度和控制器依赖的是 API 的一致性与延迟，etcd 压力会表现为控制面变慢。我会备份与看监控，不装作改过 etcd 源码。
