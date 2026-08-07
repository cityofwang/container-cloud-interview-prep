# 域 03：内存 + Host cgroup（对话沉淀）

## 三张账（必背）

| 账 | 公式 | 谁写/谁算 |
|----|------|-----------|
| **K8s 调度** | Σ request + overhead | scheduler |
| **pod cgroup limit** | Σ limit + overhead | kubelet |
| **VM Guest RAM** | default_memory + Σ limit | Kata updateResources |

**default_memory 不进 pod limit**；默认 **2048 MiB**，不配也有。

## 动态 vs static

| 模式 | VM 大小 |
|------|---------|
| dynamic（默认） | CreateSandbox：default → 每 CreateContainer 热插差额 |
| static | CreateSandbox 前：default + WorkloadMemMB；之后不热插 |
| 1.17/1.21 | **无 sandbox-memory → 勿开 static** |

## sandbox_cgroup_only

### false（默认）

| cgroup | limit | cur 组成 |
|--------|-------|----------|
| pod / kata_* | Σ limit + overhead | ~vCPU（小） |
| kata_overhead | **无** | CLH(default+Σlimit) + shim + virtiofsd |

### true

- 全家桶在 pod/kata_*；limit 同上。
- **overhead 须 ≥ default_memory + 余量**，否则 VM 热插后 Host OOM。

## default_memory 行为

- VM 启动即有；**不会**为基线单独热插。
- 热插只跟 **容器 memory.limit** 走。
- Guest 内 2Gi 先给内核+agent+I/O；热插后 **统一内存池**，非硬隔离。

## CLH + KVM 内存

- 非 malloc(2Gi)；**mmap + KVM memory region + EPT**。
- Guest GPA 连续；Host 物理页 **离散**。
- CLH **只扩不缩**；Pod 删才释 Host RSS。

## 48× 热插

单次热插 ≤ 当前 VM 内存 × 48（ACPI mem_map）；virtio-mem 无此限。

## 文档/源码

- `docs/design/host-cgroups.md`
- `virtcontainers/sandbox.go` updateResources / createResourceController
- `virtcontainers/clh.go` CreateVM / ResizeMemory
