# 源码索引：kata-containers

> **正文学习不依赖本文件。** 锚点版本 3.0.0。

| 主题 | 路径 | 说明 |
|------|------|------|
| shim Stats | `src/runtime/pkg/containerd-shim-v2/service.go` | Task.Stats 入口 |
| stats 转 metrics | `src/runtime/pkg/containerd-shim-v2/metrics.go` | statsToMetrics |
| agent 侧 stats | `src/runtime/virtcontainers/kata_agent.go` | statsContainer |
| agent RPC | `src/agent/src/rpc.rs` | stats_container, update_container |
| guest cgroup 读 | `src/agent/rustjail/src/cgroups/fs/mod.rs` | get_stats, set |
| proto | `src/libs/protocols/protos/agent.proto` | CgroupStats |
| kata-monitor | `src/runtime/pkg/kata-monitor/metrics.go` | HTTP /metrics |
| 网络 tcfilter | `src/runtime/virtcontainers/network_linux.go` | internetworking |
| Host cgroup 命名 | `src/runtime/pkg/resourcecontrol/cgroups.go` | RenameCgroupPath |
| 设计文档 | `docs/design/kata-2-0-metrics.md` | 指标设计 |
| Host cgroup | `docs/design/host-cgroups.md` | 开销 cgroup |
| 架构 3.0 | `docs/design/architecture_3.0/` | runtime-rs / Dragonball |

- **Repo**：https://github.com/kata-containers/kata-containers  
- **Version**：3.0.0  
- **本地路径**：`~/wangfanDoc/GoDemo/src/kata-containers`
