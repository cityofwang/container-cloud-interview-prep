# Kata Containers 知识域全景（全仓扫描）

> 基于上游 `kata-containers` 仓库：`docs/`、`src/runtime`、`src/agent`、`runtime-rs`、`dragonball`。  
> 生产锚点：**Go shim + CLH + K8s 1.17/1.21**。  
> 深度：**L1** 概念 · **L2** 配置/流程/排障 · **L3** 源码/生产边界

---

## 优先级分层

```text
P0 核心 — 面试高频 + 节点 Agent（Stats/Update）必会
P1 生产 — 排障与设计题常见
P2 场景 — GPU/Nydus/机密计算等，有则深问
P3 前瞻 — runtime-rs/Dragonball/打包发布，知道即可
```

---

## 28 知识域总表

| # | 域 | 子主题（摘要） | 生产 | 面试 | 深度 | 文档/源码入口 |
|---|-----|----------------|------|------|------|---------------|
| 1 | 整体架构 Shim v2 | 1 Pod 1 VM 1 shim；vs Kata 1.x | ★★★ | 高 | L2 | `docs/design/architecture/README.md` |
| 2 | E2E 创建流程 | CreateSandbox→VM→Agent→Container | ★★★ | 高 | L2 | `docs/design/end-to-end-flow.md` |
| 3 | Task API Stats/Update | containerd→shim→sandbox→agent | ★★★ | 高 | L3 | `pkg/containerd-shim-v2/service.go` |
| 4 | virtcontainers 抽象 | Sandbox/Container/Hypervisor/Agent | ★★★ | 高 | L2 | `virtcontainers/interfaces.go` |
| 5 | Host cgroup | false/true、PodOverhead、kata_overhead | ★★★ | 高 | L3 | `docs/design/host-cgroups.md` |
| 6 | Guest cgroup | rustjail、limit 写入 | ★★★ | 高 | L2 | `src/agent/rustjail/` |
| 7 | 内存管理 | default_memory、热插、static、48× | ★★★ | 高 | L3 | `virtcontainers/sandbox.go` |
| 8 | CLH 集成 | REST、ResizeMemory、virtio | ★★★ | 高 | L2 | `virtcontainers/clh.go` |
| 9 | QEMU/KVM | QMP、govmm、confidential s390x | ★★ | 中 | L2 | `virtcontainers/qemu*.go` |
| 10 | Firecracker | 极简 VMM、snapshot | ★ | 低 | L1 | `virtcontainers/fc.go` |
| 11 | Hypervisor 选型 | CLH vs QEMU vs FC vs ACRN | ★★★ | 中 | L2 | `docs/hypervisors.md` |
| 12 | Agent + ttRPC | protocols、RPC 面 | ★★★ | 高 | L2 | `src/libs/protocols/` |
| 13 | VSock 通信 | CID、hybrid、debug | ★★★ | 中 | L2 | `docs/design/VSocks.md` |
| 14 | 网络 | CNI、veth/macvlan/VFIO endpoint | ★★★ | 高 | L2 | `docs/design/architecture/networking.md` |
| 15 | 存储 rootfs | virtio-fs vs 9p、direct-blk | ★★★ | 高 | L2 | `docs/design/architecture/storage.md` |
| 16 | Nydus | lazy pull、nydusd | ★★ | 低 | L1 | `docs/design/kata-nydus-design.md` |
| 17 | 设备直通 | VFIO、GPU、SR-IOV | ★★ | 中~高 | L2 | `docs/use-cases/` |
| 18 | VMCache/Templating | 启动加速 | ★★ | 中 | L2 | `docs/how-to/what-is-vm-cache*.md` |
| 19 | Sandbox persist | shim 重启恢复 | ★★ | 低 | L2 | `virtcontainers/persist/` |
| 20 | Metrics | shim/agent/guest/hypervisor | ★★★ | 高 | L3 | `docs/design/kata-2-0-metrics.md` |
| 21 | Tracing | OpenTelemetry | ★ | 低 | L1 | `docs/tracing.md` |
| 22 | 安全 threat-model | 攻击面、privileged | ★★ | 中 | L2 | `docs/threat-model/` |
| 23 | Confidential | TDX/SEV、限制 | ★ | 场景 | L1 | CLH TdxConfig、qemu s390x |
| 24 | OCI Limitations | vs runc 差异 | ★★★ | 中 | L2 | `docs/Limitations.md` |
| 25 | Guest 镜像/kernel | osbuilder、补丁 | ★★ | 低 | L1 | `tools/osbuilder/` |
| 26 | 多架构 | arm64 热插等 | ★★ | 低 | L1 | `src/runtime/arch/` |
| 27 | runtime-rs/Dragonball | 未来栈 | ★ | 架构 | L1 | `docs/design/architecture_3.0/` |
| 28 | CI/打包/发布 | kata-deploy、versions | ★ | 低 | L1 | `tools/packaging/` |

---

## 两条技术栈

```text
【生产 — 现网】
containerd → containerd-shim-kata-v2 (Go) → virtcontainers → CLH (独立进程, KVM)
          → vsock/ttRPC → kata-agent (Guest, Rust)

【文档/未来】
containerd → runtime-rs → Dragonball (内置 VMM)
Kata 3.0.0 默认仍是 Go 路径。
```

---

## 与读代码轨道 R01–R08 映射

| 轨道 | 主要覆盖域 |
|------|------------|
| R01 | 1, 2, 4 |
| R02 | 8, 11, 27(对比) |
| R03 | 12, 13 |
| R04 | 3, 6, 20 |
| R05 | 7, 5 |
| R06 | 14 |
| R07 | 5, 24 |
| R08 | 20, 21 |

---

## 分域笔记

见 `domains/` 目录；已写：`01-architecture.md`、`02-stats-update.md`、`03-memory-cgroup.md`。

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-07 | 全仓扫描 28 域，替代「仅对话复盘」版树 |
