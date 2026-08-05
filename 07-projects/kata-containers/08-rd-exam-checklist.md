# Kata 研发必考 / 必坑清单

> **用途：** 闭卷自测、模拟面、排障前对照。  
> **配套：** `KNOWLEDGE-INDEX.md`（知识点 ID）、`pitfalls.md`（速查）、`09-code-read-protocol.md`（带问题读源码）。

## 怎么用

| 场景 | 做法 |
|------|------|
| 闭卷自测 | 文末 **10 道必答题**，≥8/10 再进下一读代码轨道 |
| 模拟面 | 考官随机抽 P0 一节 + 1 道源码指路题 |
| 新 Chat 续学 | 说 `项目专场 kata 读代码 续`（读 `SESSION-STATE.md`） |

---

## P0 — 不过线会线上踩坑

### 1. 隔离与进程模型

| 必会 | 坑 |
|------|-----|
| **三层**：Host（shim/VMM）→ Guest VM（agent）→ Guest 容器 | 「两层」「微内核」 |
| **一 Pod 一 VM**；多容器 **共享 VM** | 一容器一 VM |
| **Create 起 VM**，**Start 起 pause/业务** | VM 和 pause 都在 Start |
| shim 返回 PID = **QEMU/VMM**，不是业务 pid | 用 Host pid 当容器 pid |

### 2. 控制面：shim / agent / vsock / ttrpc

| 必会 | 坑 |
|------|-----|
| containerd Task API → shim v2 → virtcontainers → **agent** | 生产 Agent **直连 agent vsock** |
| vsock/hvsock = 控制面；virtio-net/fs = 数据面 | 用 Pod IP 访问 agent |
| Go `createSandbox()` ≠ gRPC `CreateSandboxRequest` **时机** | 混为一谈 |
| **ttrpc** 走 vsock | monitor 当 cgroup 账单源 |

### 3. 观测与资源（节点 Agent 命根子）

| 必会 | 坑 |
|------|-----|
| **双通道**：StatsContainer vs kata-monitor | 只用 monitor 做 pids 账单 |
| 参数用 **container id**，不是 sandbox id | 对 pause 调 Stats |
| Counter/Gauge、快照无内置分钟平均 | 以为 agent 有滑动窗口 |
| cadvisor 扫 Host 在 Kata 上常错对象 | Host `kata_*` 当业务 CPU |

### 4. 双层 cgroup

| 必会 | 坑 |
|------|-----|
| **Host cgroup**：VMM/shim/vCPU | 业务计费读 Host |
| **Guest cgroup**：真实容器 limits/usage | limits 只写在 Host |
| **PodOverhead** + **sandbox_cgroup_only** | 忽略 overhead 规划 |
| **static_resource_mgmt** | 以为 Update memory 一定热扩 VM |

### 5. Hypervisor 选型（实现层差异）

| VMM | 控制面 | 特点 | 场景 |
|-----|--------|------|------|
| QEMU | vsock | 设备最全、成熟 | 通用默认 |
| Cloud Hypervisor | hvsock | 精简、启动快 | 云原生高性能 |
| Firecracker | hvsock | 极简、设备受限 | FaaS/高密度 |
| Dragonball | vsock 系 | 内置 VMM 方向 | Kata 3.0 一体化 |

**坑：** 换 VMM 不换 `configuration-*.toml`；FC 缺设备导致根盘/网络异常。

### 6. 网络

| 必会 | 坑 |
|------|-----|
| Host sandbox netns ≠ Guest Pod netns | 一容器一 veth |
| **tcfilter**：veth↔tap 双向 redirect | tc ingress = K8s Ingress |
| StartVM 在 sandbox netns 内 | 网络查错层 |

### 7. 存储

| 必会 | 坑 |
|------|-----|
| virtio-fs + virtiofsd（常见） | 镜像只在 Host 不用进 VM |
| block/dm（高 I/O 可选） | 存储限额 ≠ memory cgroup |

---

## P1 — 生产研发必备

- **configuration.toml 基线**：`internetworking_model`、`sandbox_cgroup_only`、`static_resource_mgmt`
- **Limitations 思维**（`docs/Limitations.md`）：相对 runc 不是 bug 是架构
- **源码地图**：见 `sources.md` + `09-code-read-protocol.md` 轨道 R01–R08
- **排障分层**：shim/agent → Guest eth0 → Host sandbox ns → VMM → CNI

---

## P2 — 架构加分

- Kata 2.x（Go virtcontainers）vs 3.0（runtime-rs + Dragonball）
- Factory/VMCache 与 virtio-fs 等约束
- RuntimeClass + 多 runtime 混部

---

## 10 道必答题（闭卷）

1. 三层分别是什么？nginx 的 cgroup 在哪层读？
2. VM 在 Create 还是 Start？pause 呢？
3. Stats 和 monitor 分工？生产 Agent 接谁？
4. QEMU vs CLH：agent 连接方式差在哪？
5. 改 `pids.max` 的 API 链？为何不用 Exec 写 cgroup？
6. Host `kata_*` cgroup 代表什么？
7. tcfilter 解决什么？TAP 在哪一层？
8. Go `createSandbox()` 与 gRPC `CreateSandboxRequest` 分别何时执行？
9. `sandbox_cgroup_only=true` 要注意什么？
10. 说出 2 条相对 runc 的 Limitations 类差异。

---

## 你的角色最小必会包（物理机 Agent）

1. containerd Stats/Update + **container id**
2. 不直连 vsock；RuntimeAdapter 分 runc/Kata
3. Guest Stats vs Host VMM/monitor **分开大盘**
4. 节点 configuration 基线登记
5. Create VM 链（知道 agent 何时 ready）
6. VMM 选型只影响排障路径，**不改变 Agent API 选型**
