# 自测：Kata MVP 冒烟（10 题）

> 规则：**先写答案/口述，再对要点**。过关线：≥8/10。

## 题

1. Kata 三层环境分别是什么？业务 nginx 的 pid 在哪一层？

2. 「一 Pod 一 VM」是什么意思？一个 Pod 里 app + sidecar 几个 VM？

3. vsock 和 virtio-net 分别承担什么？

4. Stats 和 kata-monitor 的核心区别是什么？各适合什么场景？

5. 从 containerd 到 Guest cgroup 读 memory.usage，中间经过哪几个组件？（至少 4 步）

6. 动态修改 pids.max 应走什么 API？为什么不推荐 exec 写 cgroup 文件？

7. container id 和 sandbox id 有什么区别？Stats 应该用哪个？

8. 为什么 cadvisor 在 Kata 节点上容易误导业务 CPU？

9. cgroup 指标里 Counter 和 Gauge 分别怎么算「1 分钟平均」？

10. **对比：** runc Pod 和 Kata Pod，kubelet 调 CRI Stats 时，数据最终从哪读 cgroup？

---

## 参考要点（自答后核对）

| # | 要点 |
|---|------|
| 1 | Host / Guest VM / Guest 容器；pid 在 Guest 容器层 |
| 2 | 一 Pod 一 sandbox/VM；多容器共享 **1** 个 VM |
| 3 | vsock=控制 ttrpc；virtio-net=业务网络数据面 |
| 4 | Stats=per-container cgroup；monitor=VMM/shim/guest /proc |
| 5 | containerd → shim.Stats → vsock StatsContainer → agent → rustjail get_stats |
| 6 | Task.Update → UpdateContainer；exec 路径/权限/驱动不可靠 |
| 7 | sandbox=Pod/VM；container=各容器；Stats 用 **container id** |
| 8 | 业务在 Guest cgroup，Host 上是 VMM 线程 |
| 9 | Gauge 采样平均；Counter 两次差分/时间 |
| 10 | runc：Host cgroup；Kata：Guest cgroup（经 shim→agent） |

## 过关后

- 在 `KNOWLEDGE-INDEX.md` 把 K01/K05/K06/K12/K15/K16 标 `会`  
- `PROJECT.md` 学习状态 → `可口述`（若 10/10 且能画 Stats 链路）
