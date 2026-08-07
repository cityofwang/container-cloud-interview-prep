# Kata 模拟面试 40 题

> 自测：闭卷口述 ≥32/40。答案要点见 `domains/`、`SESSION-STATE.md`。

## 架构（1–8）

1. 一个 Kata Pod 几个 shim？几个 CLH 进程？
2. shim 返回的 PID 是谁的？
3. Kata 3.0.0 与 architecture_3.0 文档栈有何区别？
4. pause 容器在 Guest 里干什么？提供网络吗？
5. agent 为何有两个 CreateSandbox？
6. VMM 与 KVM 的关系？
7. runtime-rs / Dragonball 解决什么问题？生产默认用吗？
8. Kata vs runc 隔离边界在哪一层？

## Stats / Update（9–16）

9. CRI Stats 的 memory 读 Host 还是 Guest？
10. Stats 为什么用业务 container id？
11. ctr 能 update task 资源吗？用什么？
12. vsock 在监控链路里处于什么位置？节点 Agent 该不该直连？
13. kata-monitor 与 containerd Stats 区别？
14. Update memory 会改 Host pod cgroup limit 吗？
15. Update 后 VM 内存谁负责热插？
16. false 模式下 kubectl top pod 为何可能偏小？

## 内存（17–26）

17. default_memory 不配是多少？
18. VM 目标内存公式？
19. CreateSandbox 时 VM 多大？全部容器 limit 何时进 VM？
20. static 模式在 1.21 无 sandbox-memory 会怎样？
21. sandbox-memory annotation 是什么？1.21 有吗？
22. CLH 能缩内存吗？
23. 48× 热插限制原因？
24. default_memory 会单独热插扩容吗？
25. 容器 OOM 重启后 VM 内存为何可能不变？
26. Host 上 Guest 2Gi 物理连续吗？

## cgroup / K8s（27–34）

27. PodOverhead 参与调度还是 limit？
28. false 模式 pod cur 与 overhead cur 各是什么？
29. true 模式 overhead 配太小会怎样？
30. Kata 会改 kubelet 写的 pod memory limit 吗？
31. RuntimeClass handler 与 containerd 什么对应？
32. 三张账：sandbox-memory、pod limit、VM 目标？
33. Guest 容器 cgroup limit 谁写？
34. rename kata_ 前缀目的？

## 网络 / 存储 / 其他（35–40）

35. CNI 在 Host 还是 Guest 配置？
36. rootfs 怎么进 VM？virtio-fs 与 9p 一句对比。
37. Limitations.md 为何要读？
38. VMCache 与 VM Templating 区别？
39. 节点规划 a=2Gi b=3Gi default=2Gi Pod，Host 至少留多少内存（粗算）？
40. BestEffort 无 limit 容器时 VM 大小风险？

---

## 参考答案索引

| 题号 | 见 |
|------|-----|
| 1–8 | `domains/01-architecture.md`、SESSION-STATE R01–R03 |
| 9–16 | `domains/02-stats-update.md`、`03-observability.md` |
| 17–26 | `domains/03-memory-cgroup.md` |
| 27–34 | 同上 + host-cgroups.md |
| 35–40 | LEARNING-8W W6–W7、GAPS.md |
