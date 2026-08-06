# Kata 学习会话状态

> **新 Chat 第一件事：** 助手读此文件 + `09-code-read-protocol.md`，再 `SESSION-STATE` 里的「下次口令」开场。  
> **学员只需说：** `项目专场 kata 读代码 续`

最后更新：**2026-08-06**  
学习模式：**代码导读 + 概念**  
源码路径：`~/wangfanDoc/GoDemo/src/kata-containers`（锚点 **3.0.0**）

---

## 当前进度

| 项 | 值 |
|----|-----|
| **当前轨道** | **R04**（Stats 全链 — 概念已讲，源码未系统带读） |
| **Concept 章节** | `00-one-pager` ✅ · `03-observability` ✅ · Host cgroup / VM 内存（对话沉淀）✅ |
| **上次结论** | K8s 下 VM 内存 **按 CreateContainer 逐步热插**；CLH **只扩不缩**；监控走 **containerd/CRI**，不直连 vsock |
| **下次口令** | `项目专场 kata 读代码 R04` |

---

## 轨道完成情况

| 轨道 | 主题 | 状态 | 日期 |
|------|------|------|------|
| R01 | PodSandbox → shim Create | **✅ 概念+锚点** | 2026-08-04～06 |
| R02 | startVM / hypervisor (CLH) | **半会**（startVM 顺序、CLH ResizeMemory 读过） | 2026-08-06 |
| R03 | agent 双 CreateSandbox | **半会**（Go vs gRPC 命名区分） | 2026-08-04～06 |
| R04 | StatsContainer 全链 | **进行中**（文档+观测结论；`service.go Stats` 链未带读） | 2026-08-06 |
| R05 | UpdateContainer / VM 内存 | **半会**（updateResources、static 模式、无 sandbox-memory） | 2026-08-06 |
| R06 | tcfilter / TAP | 未开始 | — |
| R07 | Host cgroup | **半会**（false/true、PodOverhead、三张账） | 2026-08-06 |
| R08 | kata-monitor | **半会**（与 containerd 双通道、shim-monitor.sock） | 2026-08-06 |

---

## 对话沉淀（跨 Chat 上下文）

以下从 2026-08 对话提炼，**新 Chat 可直接当已知前提**，不必重讲：

### 生命周期 / 进程模型（R01）

1. **Create/Start**：RunPodSandbox **Create** → `startVM` + Guest 内 `createContainers(pause)`；**Start** 只 start pause；业务容器单独 **CreateContainer/StartContainer**。
2. **shim 返回 PID** = **VMM（CLH/QEMU）**，不是 Guest 内业务 pid。
3. **pause**：Guest 内完整 OCI 容器，锚定 Pod 生命周期；**不提供网络/镜像**（网络靠 Host CNI + `createNetwork`）。
4. **ctr 单容器**：无 pause，workload 即 sandbox 唯一容器；网络仍走同一套 `createNetwork`。
5. **agent 双 CreateSandbox**：Go `agent.createSandbox()`（VM 前，vsock+virtio-fs）→ `startVM` → gRPC `CreateSandboxRequest`（VM 后，Guest 网络/挂盘）。

### VM / 内存 / CPU（R02/R05）

6. **VMM vs KVM**：VMM = CLH/QEMU 进程；KVM = `/dev/kvm` 能力接口。
7. **VM 内存目标** ≈ `default_memory` + Σ **运行中**容器 memory limit（`calculateSandboxMemory`）；**不含** PodOverhead。
8. **K8s 时序（dynamic，默认）**：CreateSandbox 仅 default → 每个 **CreateContainer** 后 `updateResources` **重算总和、只热插差额**（不是 CreateSandbox 一次性 Σ limit）。
9. **`io.kubernetes.cri.sandbox-memory`** = Σ 容器 limit（字节），**不是** PodOverhead，**不是** pod cgroup 总 limit；**K8s 1.17/1.21 无此 annotation**。
10. **`static_sandbox_resource_mgmt=true`**：CreateSandbox 前一次性定 VM 大小；之后 **不再 updateResources**；**无 sandbox-memory 时勿开**（VM 锁死在 default_memory）。
11. **48 倍热插**：ACPI 热插 Guest mem_map 限制；单次 ≈ 当前 VM 内存 × 48；virtio-mem 无此限；CLH 默认 ACPI 路径。
12. **VM 内存缩减**：QEMU hot-unplug 未实现；**CLH 明确不支持减内存**（`Remove memory is not supported`）；Pod 删除才释放 Host RSS。
13. **容器 OOM 重启**：目标 memory 不变 → `ResizeMemory` early return，**不再热插**；Guest 页在 VM 池内复用。
14. **balloon**：长期方案用 virtio balloon 把闲置页还给 Host；Kata 生产路径尚未依赖。

### Host / Guest cgroup（R07）

15. **`sandbox_cgroup_only=false`（默认）**：pod/kata_xxx  mainly **vCPU**；**kata_overhead** 放 shim+VMM+I/O（CLH RSS 在此）。
16. **PodOverhead**：RuntimeClass 配置；kubelet 调度/admission + pod cgroup sizing；**Kata 不直接读**。
17. **三张账**：sandbox-memory（Σ容器）· pod cgroup limit（Σ+Overhead）· Kata VM 目标（default+Σ）。

### 架构 / 版本

18. **Kata 3.0.0 ≠ architecture 3.0 生产栈**：默认仍是 **Go `virtcontainers` + 外挂 CLH**；`architecture_3.0/` 描述 **runtime-rs + Dragonball**（roadmap，CLH 在 runtime-rs 为 Stage 3 🚫）。
19. **roadmap** = runtime-rs 功能演进计划（Stage 1/2/3 + ✅🚧🚫），不是 Go runtime 能力表。

### 观测（R04/R08）

20. **对外契约**：CRI **ContainerStats** / containerd **Task.Stats**（`kata-2-0-metrics.md` 开篇）；架构：workload **通过 Guest cgroup 监控**（`architecture/README.md`）。
21. **vsock→agent** 是 **shim 内部实现**（StatsContainer、GetMetrics）；节点 Agent **接 containerd SDK**，文档无「禁止 vsock」原话，但未列为用户 API。
22. **kata-monitor**：Host 上 `shim-monitor.sock` → shim → 内部 agent；与 containerd **不同通道**，仍 **不直连 vsock**。
23. **Host 开销**：读 pod cgroup 或 `/kata_overhead`（`host-cgroups.md`）。

### 项目方向

24. **节点 Agent**：containerd Task.Stats/Update，RuntimeAdapter 分 runc/Kata；见 `03-observability.md`、`pitfalls.md` #8。
25. **JD 技能对齐（2026-08-06）**：主投研发岗 #1/#5/#6 → containerd/CRI/Kata/Operator/可观测；详见 `review/job-market/2026-08-06-user-jd-batch-scan.md`。

---

## 进行中（下场填）

| 项 | 内容 |
|----|------|
| 待答探测题 | R04：Stats 从 crictl 到 Guest cgroup 经过几跳？Counter 怎么用？ |
| 待打开文件 | `pkg/containerd-shim-v2/service.go` Stats → `metrics.go` → `kata_agent.statsContainer` |
| 未闭合问题 | R06 网络全链；R07 源码 `setupResourceController` 带读；static+sandbox-memory 在 1.23+ 的完整时序 |

---

## 源码锚点（本场已打开）

| 主题 | 文件 |
|------|------|
| Create/Start | `pkg/containerd-shim-v2/create.go`, `virtcontainers/api.go` |
| updateResources / 48x | `virtcontainers/sandbox.go` |
| CLH 内存 | `virtcontainers/clh.go` ResizeMemory |
| sandbox-memory | `pkg/oci/utils.go` CalculateSandboxSizing |
| Stats 入口 | `pkg/containerd-shim-v2/service.go` Stats |
| 观测设计 | `docs/design/kata-2-0-metrics.md` |

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-04 | 初版：读代码协议 + 必考清单落仓；轨道全未开始 |
| 2026-08-06 | 对齐学员 6 岗 JD；R04 对 #5/#6 可观测优先级上调 |
| 2026-08-06 | **大段 context 沉淀**：R01✅、R02/R03/R05/R07/R08 半会；VM 内存/CLH/static/sandbox-memory/3.0 架构/监控路径写回 |
