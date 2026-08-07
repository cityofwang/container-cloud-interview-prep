# 项目：kata-containers

| 字段 | 值 |
|------|-----|
| 全称 | Kata Containers |
| 版本 | 3.0.0（学习锚点） |
| 上游 | https://github.com/kata-containers/kata-containers |
| 本地 clone | `~/wangfanDoc/GoDemo/src/kata-containers`（可选，仅 sources 索引） |
| 你的角色 | 物理机服务：Kata workload 监控、资源限制（pids/CPU/memory）、可能 in-container 操作 |
| 学习目标 | **两者**（落地服务 + 面试深挖） |
| **学习状态** | `MAP+`（28 域全景 + 8W 排期 + domains + R01–R08 协议） |
| 关联故事卡 | S2 cgroup、S5 监控排障 → 待升 **S6** |
| 关联 KNOWLEDGE-MAP | C1 隔离/CNI、C2 可观测、C3 cgroup/混部 |
| 创建日期 | 2026-07-31 |
| 上次学习 | 2026-08-07 |
| 续聊入口 | **`CONTINUITY.md`** → `SESSION-STATE.md` + 口令 `项目专场 kata 读代码 续` |

## 一句话

Kata = **一 Pod 一轻量 VM + Guest 内再跑容器**；你要做的节点 Agent 应走 **containerd Task.Stats/Update**，读 **Guest 容器 cgroup**，而不是 Host VMM cgroup 或仅 kata-monitor。

## 学习排期（与 FZ 关系）

| 周 | 内容 | 时长 | 与 FZ |
|----|------|------|-------|
| W1 ✅ | `00-one-pager` + `03-observability` | ~2h | 平行 P 轨，不打乱 **FZ1** |
| W2 | `01-isolation-and-cgroup` | ~1.5h | 挂 **FZ5** / S2 前预热 |
| W3 | `02-cri-shim-agent` + `04-network` | ~2h | 挂 FZ1 CNI、流程清单 |
| W4 | `07-production-agent-design` | ~1h | 合 **S6** 故事卡 |

**默认：** 周末 FZ 包结束后加 `项目专场 kata`；平日仍错题回炉。

## 章节进度

| 章节 | 状态 | 上次 |
|------|------|------|
| `00-one-pager.md` | ✅ 会读 | 2026-07-31 |
| `03-observability.md` | ✅ 会读 | 2026-07-31 |
| `01-isolation-and-cgroup.md` | 未写 | — |
| `02-cri-shim-agent.md` | 未写 | — |
| `04-network-tcfilter-tap.md` | 未写 | — |
| `pitfalls.md` | ✅ 索引 | 2026-07-31 |
| `08-rd-exam-checklist.md` | ✅ | 2026-08-04 |
| `09-code-read-protocol.md` | ✅ | 2026-08-04 |
| `SESSION-STATE.md` | ✅ 进行中 | 2026-08-07 |
| `CONTINUITY.md` | ✅ | 2026-08-07 |
| `KNOWLEDGE-MAP.md` | ✅ 28 域 | 2026-08-07 |
| `LEARNING-8W.md` | ✅ | 2026-08-07 |
| `SOURCE-TRAIL.md` | ✅ | 2026-08-07 |
| `GAPS.md` | ✅ | 2026-08-07 |
| `MOCK-INTERVIEW-40.md` | ✅ | 2026-08-07 |
| `domains/` | ✅ 01–03 | 2026-08-07 |
| `quizzes/01-smoke.md` | ✅ | 2026-07-31 |

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-07-31 | P 轨 MVP：骨架 + one-pager + observability |
| 2026-08-04 | 必考清单 + 读代码协议 R01–R08 + SESSION-STATE 续聊 |
| 2026-08-07 | 全仓 KNOWLEDGE-MAP 28 域 + LEARNING-8W + CONTINUITY + domains + MOCK-40 |
