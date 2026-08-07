# Kata 8 周学习计划（全局版）

> 角色：节点 Agent 开发（containerd Task.Stats/Update，Guest cgroup）  
> 环境：K8s **1.17/1.21** · **CLH** · containerd · `sandbox_cgroup_only=false` 默认  
> 源码：`~/wangfanDoc/GoDemo/src/kata-containers`（3.0.0）  
> 假设：**每周 ~10h**（可压成 6 周：合并 W6+W7 或跳过 P2）

---

## 阶段目标

| 阶段 | 周 | 目标深度 |
|------|-----|----------|
| 基础 | W1–W2 | 架构 L2、Limitations L2 |
| 主线 | W3–W5 | Stats/Update/内存 L3 |
| 扩展 | W6–W7 | 网络/存储 L2 |
| 综合 | W8 | 模拟面试 + 缺口回填 |

---

## 周计划

| 周 | 主题 | 必读文档 | 必读源码 | 实验/产出 | 验收 |
|----|------|----------|----------|-----------|------|
| **W1** | 架构 + E2E + 双栈 | `architecture/README.md`、`end-to-end-flow.md`、`hypervisors.md` | `create.go`、`api.go` | 全链路时序图 | 白板 5min 讲完 containerd→CLH→agent |
| **W2** | 生命周期 + Limitations | `Limitations.md`、`kubernetes.md` | `container.go` | runc vs Kata 进程树对比 | 说 3 条 Kata 与 runc 行为差异 |
| **W3** | **Stats 全链** | `kata-2-0-metrics.md` | `service.go` Stats、`kata_agent.go`、`rpc.rs` | ctr/crictl stats 对照 | 闭卷：Stats 经过几跳？读 Guest 还是 Host？ |
| **W4** | **Update + vCPU** | `host-cgroups.md`、`vcpu-handling.md` | `UpdateContainer`、`updateResources` | crictl update | Update 改的是哪几层 cgroup/VM？ |
| **W5** | 内存 + CLH + KVM | `virtualization.md` | `clh.go` CreateVM/ResizeMemory | 节点 CLH RSS + cgroup | 口述 default+热插+false 模式 cur |
| **W6** | **网络** | `architecture/networking.md` | `network*.go` | trace Pod 网卡进 Guest | CNI 在 Host 还是 Guest？ |
| **W7** | **存储** | `architecture/storage.md`、virtio-fs how-to | `fs_share*.go` | rootfs 路径 | virtio-fs vs 9p 一句对比 |
| **W8** | 综合 | VMCache how-to、threat-model | `shim_metrics.go`、`factory/` | `MOCK-INTERVIEW-40.md` 自测 | ≥32/40 |

---

## 与旧 PROJECT.md 排期关系

| 旧章节 | 并入 |
|--------|------|
| `01-isolation-and-cgroup` | W4–W5 + `domains/03-memory-cgroup.md` |
| `02-cri-shim-agent` | W1–W3 |
| `04-network-tcfilter-tap` | W6 |
| `07-production-agent-design` | W3–W4 + W8 |

---

## 选学（替换 W8 或加 Week 9）

| 主题 | 何时 |
|------|------|
| VFIO/GPU | JD 含 GPU |
| Nydus | 镜像加速团队 |
| runtime-rs / architecture_3.0 | 架构面 |
| Firecracker | FC 生产 |
| osbuilder/kernel | 镜像定制 |

---

## 每日微习惯（15min）

1. 看一个 cgroup 路径或记一条 `pitfalls.md`
2. 更新 `KNOWLEDGE-INDEX.md` 里 1 个 Kxx 状态

---

## K8s 1.17/1.21 裁剪

- **勿依赖** `sandbox-memory`（1.23+）→ **static 默认关**
- **PodOverhead** 1.18+；1.17 调度不含 overhead
- 监控：**Task.Stats**，不直连 vsock

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-07 | 全仓扫描版 8W，对齐 KNOWLEDGE-MAP 28 域 |
