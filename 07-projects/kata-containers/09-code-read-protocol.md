# Kata 带问题读代码协议

> **目标：** 面试 + 理解 + 研发，在同一条链上——**先答/先猜 → 再打开文件 → 场末写回 SESSION-STATE**。  
> **源码根：** `~/wangfanDoc/GoDemo/src/kata-containers`（锚点 3.0.0）  
> **索引：** `sources.md`

---

## 新 Chat 怎么让我「接上」

Cursor **不会**自动记得上一段对话。续学靠 **三件套**：

| 文件 | 作用 |
|------|------|
| **`CONTINUITY.md`** | **跨 Chat 唤醒**：口令表、文件读序、2026-08-07 沉淀摘要 |
| **`SESSION-STATE.md`** | 写到哪、答到哪、下次从哪条轨道继续 |
| **`KNOWLEDGE-MAP.md`** | 28 知识域全景（全仓扫描） |
| **`LEARNING-8W.md`** | 8 周排期 |
| **本文件 `09-code-read-protocol.md`** | 每条轨道的题目 + 文件顺序 |
| **口令** | 触发助手读上述文件 |

**推荐开场（复制即用）：**

```text
项目专场 kata 读代码 续
本地源码：~/wangfanDoc/GoDemo/src/kata-containers
请严格按 SESSION-STATE.md 与 09-code-read-protocol.md 执行：先出题等我答，再带读代码。
```

**指定轨道：**

```text
项目专场 kata 读代码 R04
```

**概念 + 代码组合：**

```text
项目专场 kata 读代码 R02
探索专场 kata Create/Start
```

助手应读：`project-learn` Skill → `PROJECT.md` → `SESSION-STATE.md` → 本文件对应轨道 → **先 1～2 探测题** → 你答完再 `Read` 源码。

---

## 单场节奏（45～60min）

```text
1. 报状态：轨道、文件、关联 Kxx
2. 探测题 1～2（闭卷，禁止先贴大段代码）
3. 你答（不会也算）
4. 短纠偏 + 打开入口文件（带行号引用）
5. 沿调用链往下读 2～4 个锚点函数
6. 加压题 1 道（面试/线上坑）
7. 写回 SESSION-STATE.md + 更新 KNOWLEDGE-INDEX 状态
```

**铁律：** 同 `interview-coach` / `explore-coach` — **先答后讲**；读代码时也先让学员说「我猜这段在干什么」。

---

## 读代码轨道 R01–R08

状态列：`未开始` / `进行中` / `✅` — 以 `SESSION-STATE.md` 为准。

### R01 — PodSandbox 从 CRI 到 shim Create

| 项 | 内容 |
|----|------|
| 关联 Kxx | K04, K06 |
| 探测题 | VM 在 `Create` 还是 `Start` 起来？shim 返回的 PID 是谁？ |
| 阅读顺序 | `pkg/containerd-shim-v2/create.go` → `service.go`（CreateTask）→ `virtcontainers/sandbox.go`（createSandbox） |
| 锚点 | `create()`、`createSandbox()`、`CreateContainer` 与 sandbox 关系 |
| 坑 | pause 容器与 VM 启动顺序；sandbox id vs container id |
| 场末 | 能画 8 步时序（containerd → shim → virtcontainers） |

### R02 — startVM 与 hypervisor 启动

| 项 | 内容 |
|----|------|
| 关联 Kxx | K06, K18 |
| 探测题 | QEMU 进程在哪一层 cgroup？TAP 在哪个 netns 创建？ |
| 阅读顺序 | `virtcontainers/sandbox.go`（startVM）→ `virtcontainers/vm.go` → `pkg/katautils/config.go`（读 hypervisor 配置） |
| 锚点 | `startVM`、`CreateVM`、configuration 选 VMM |
| 坑 | StartVM 须在 sandbox netns；换 VMM 换 toml |
| 文档 | `docs/hypervisors.md` |

### R03 — agent 两条「CreateSandbox」

| 项 | 内容 |
|----|------|
| 关联 Kxx | K08 |
| 探测题 | Go `agent.createSandbox()` 和 proto `CreateSandboxRequest` 各做什么、谁先谁后？ |
| 阅读顺序 | `virtcontainers/kata_agent.go`（createSandbox / startSandbox）→ `agent.proto` → `src/agent/src/rpc.rs`（create_sandbox） |
| 锚点 | vsock 建连时机、gRPC/ttrpc 首包 |
| 坑 | 配置 virtio-fs vsock **在 VM 前**；Guest 网络 **在 VM 后** |

### R04 — StatsContainer 全链（你的 Agent 核心）

| 项 | 内容 |
|----|------|
| 关联 Kxx | K12, K15, K16 |
| 探测题 | crictl/stats 用的是 sandbox id 还是 container id？读的是哪层 cgroup？ |
| 阅读顺序 | `shim-v2/service.go`（Stats）→ `metrics.go` → `kata_agent.go`（statsContainer）→ `agent rpc.rs` → `rustjail/.../cgroups/fs/mod.rs` |
| 锚点 | `statsToMetrics`、Guest cgroup 路径 |
| 坑 | 勿用 Host `kata_*`；Stats 是快照不是分钟均值 |
| 场末 | 口述 containerd SDK 等价调用 |

### R05 — UpdateContainer 与 limits

| 项 | 内容 |
|----|------|
| 关联 Kxx | K14, K03 |
| 探测题 | 改 pids.max 走 Exec 还是 Task.Update？会改 Host 还是 Guest？ |
| 阅读顺序 | `service.go`（Update）→ `kata_agent.go`（updateContainer）→ `rustjail` set |
| 锚点 | `static_resource_mgmt` 行为 |
| 坑 | memory Update 不一定热扩 VM |

### R06 — 网络 tcfilter / TAP

| 项 | 内容 |
|----|------|
| 关联 Kxx | K10 |
| 探测题 | 一个 Pod 几个 Host veth？tc ingress 和 K8s Ingress 有关系吗？ |
| 阅读顺序 | `virtcontainers/network_linux.go` → 对照 `configuration.toml` `internetworking_model` |
| 坑 | Host veth 与 Guest eth0 是管道两端 |

### R07 — Host cgroup 命名与 PodOverhead

| 项 | 内容 |
|----|------|
| 关联 Kxx | K13, K14, K21 |
| 探测题 | 业务 CPU 飙高，先看 Guest Stats 还是 Host kata cgroup？ |
| 阅读顺序 | `pkg/resourcecontrol/cgroups.go` → `docs/design/host-cgroups.md` |
| 坑 | cadvisor 默认扫 Host |

### R08 — kata-monitor vs shim metrics

| 项 | 内容 |
|----|------|
| 关联 Kxx | K12, K22 |
| 探测题 | monitor 的 `/metrics` 和 Task.Stats 能否互相替代？ |
| 阅读顺序 | `pkg/kata-monitor/metrics.go` → `docs/design/kata-2-0-metrics.md` |
| 场末 | 设计节点大盘：哪些 panel 用哪条通道 |

---

## 建议顺序

```text
已会概念：00-one-pager, 03-observability
读代码：R01 → R03 → R04 → R05 → R02 → R06 → R07 → R08
```

R04 与你做的 **物理机 Agent** 最直接，可在 R01/R03 后提前。

---

## 与 X 轨 / 面试轨组合

| 组合 | 口令 |
|------|------|
| 代码 + 深度追问 | `项目专场 kata 读代码 R04` + 场中 `关联一下 Stats` |
| 代码 + 模拟面 | 读完 R04 后 `校准面 kata 可观测` |
| 只概念不读码 | `项目专场 kata 03-observability` |

---

## 场末写回清单

- [ ] 更新 `SESSION-STATE.md`（轨道、文件、结论一句话）
- [ ] 更新 `KNOWLEDGE-INDEX.md` 对应 Kxx 状态
- [ ] 错题写入 `review/wrong-book.md`（若适用）
- [ ] 一句话：**下次口令**
