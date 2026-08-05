# 知识点索引：kata-containers

状态：`未学` / `半会` / `会` — 以自测 + 闭卷口述为准。

## P0（必须先会）

| ID | 知识点 | 章节 | KNOWLEDGE-MAP | 状态 |
|----|--------|------|---------------|------|
| K01 | 三层隔离 Host/VM/容器 | `00-one-pager` | C1 隔离 | 半会 |
| K04 | OCI→CRI→containerd→shim | `00-one-pager` · `02-*` | C1 Pod 创建 | 半会 |
| K05 | Kata vs runc | `00-one-pager` | C1 隔离 | 半会 |
| K06 | 一 Pod 一 VM、多容器共享 | `00-one-pager` | C1 工作负载 | 半会 |
| K12 | Stats vs monitor 双通道 | `03-observability` | C2 可观测 | 半会 |
| K15 | Update/Stats API 链 | `03-observability` | C2/C3 | 半会 |
| K16 | container id vs sandbox id | `03-observability` | C1 | 半会 |

## P1（生产/面试）

| ID | 知识点 | 章节 | KNOWLEDGE-MAP | 状态 |
|----|--------|------|---------------|------|
| K03 | cgroup Gauge/Counter | `01-isolation-and-cgroup` | C3 | 未学 |
| K08 | vsock + ttrpc 控制面 | `02-cri-shim-agent` | — | 未学 |
| K13 | Host vs Guest 双层 cgroup | `01-isolation-and-cgroup` | C3 | 未学 |
| K14 | sandbox_cgroup_only + PodOverhead | `05-resources-update` | C3 QoS | 未学 |
| K19 | 生产接 containerd SDK | `07-production-agent-design` | C2 | 未学 |
| K21 | cadvisor/Host cgroup 误读 | `03-observability` · `pitfalls` | C2 | 半会 |
| K22 | 分钟级监控（快照+差分） | `03-observability` | C2 | 半会 |

## P2（架构/进阶）

| ID | 知识点 | 章节 | KNOWLEDGE-MAP | 状态 |
|----|--------|------|---------------|------|
| K10 | CNI + tcfilter + TAP | `04-network-tcfilter-tap` | C1 CNI | 未学 |
| K18 | Hypervisor 选型 | `06-hypervisor-and-3.0` | — | 未学 |
| K23 | RuntimeAdapter | `07-production-agent-design` | — | 未学 |
| K27 | Kata 2.x vs 3.0 | `06-hypervisor-and-3.0` | — | 未学 |

## 读代码轨道（带 SESSION-STATE 续聊）

| 轨道 | 主题 | 关联 Kxx | 协议 |
|------|------|----------|------|
| R01 | shim Create | K04,K06 | `09-code-read-protocol.md` |
| R02 | startVM | K06,K18 | 同上 |
| R03 | agent CreateSandbox | K08 | 同上 |
| R04 | Stats 全链 | K12,K15,K16 | 同上 |
| R05 | Update | K14,K03 | 同上 |
| R06 | tcfilter | K10 | 同上 |
| R07 | Host cgroup | K13,K14,K21 | 同上 |
| R08 | monitor | K12,K22 | 同上 |

**口令：** `项目专场 kata 读代码 续` · 必考清单：`08-rd-exam-checklist.md`

## 建议学习顺序

1. ✅ `00-one-pager.md`
2. ✅ `03-observability.md` + `quizzes/01-smoke.md`
3. **`09-code-read-protocol` R01→R03→R04**（概念+源码）
4. `01-isolation-and-cgroup.md`（接 FZ5 / S2）
5. `02-cri-shim-agent.md` + R05–R08
6. `04-network-tcfilter-tap.md`
7. `07-production-agent-design.md` + 更新 S6

## 与 notes/ 互链

| 通用笔记 | 本项目加深 |
|----------|------------|
| `notes/` namespace/cgroup（待写 B-thin） | K01/K13 |
| `k8s-troubleshoot-crashloop-oom-notready.md` | Guest OOM vs Host VMM OOM |
| `k8s-event-auto-remediation-design.md` | 节点 Agent 别直连 vsock |
