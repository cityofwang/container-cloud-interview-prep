# Kata 学习会话状态

> **新 Chat 第一件事：** 助手读此文件 + `09-code-read-protocol.md`，再 `SESSION-STATE` 里的「下次口令」开场。  
> **学员只需说：** `项目专场 kata 读代码 续`

最后更新：**2026-08-04**  
学习模式：**代码导读 + 概念**  
源码路径：`~/wangfanDoc/GoDemo/src/kata-containers`

---

## 当前进度

| 项 | 值 |
|----|-----|
| **当前轨道** | `R01`（未开始 — 待首场读代码） |
| **Concept 章节** | `00-one-pager` ✅ · `03-observability` ✅ |
| **上次结论** | VM 在 **Create** 起；Stats 走 **Guest cgroup**；生产 **不接 vsock** |
| **下次口令** | `项目专场 kata 读代码 R01` |

---

## 轨道完成情况

| 轨道 | 主题 | 状态 | 日期 |
|------|------|------|------|
| R01 | PodSandbox → shim Create | 未开始 | — |
| R02 | startVM / hypervisor | 未开始 | — |
| R03 | agent 双 CreateSandbox | 未开始 | — |
| R04 | StatsContainer 全链 | 未开始 | — |
| R05 | UpdateContainer | 未开始 | — |
| R06 | tcfilter / TAP | 未开始 | — |
| R07 | Host cgroup | 未开始 | — |
| R08 | kata-monitor | 未开始 | — |

---

## 对话沉淀（跨 Chat 上下文）

以下从 2026-08 对话提炼，**新 Chat 可直接当已知前提**，不必重讲：

1. **Create/Start 分工**：RunPodSandbox **Create** 起 VM；**Start** 起 pause；业务容器再 Create。
2. **agent 命名**：Go 侧 `createSandbox()` 配 vsock/virtio-fs；gRPC `CreateSandboxRequest` 在 VM 起来后配 Guest 网络/存储。
3. **观测**：StatsContainer（containerd）vs kata-monitor（VMM/guest proc）— 双通道。
4. **研发必考清单**：见 `08-rd-exam-checklist.md`。
5. **你的项目方向**：节点 Agent → containerd Task.Stats/Update，RuntimeAdapter 分 runc/Kata。

---

## 进行中（下场填）

| 项 | 内容 |
|----|------|
| 待答探测题 | R01：VM 在 Create 还是 Start？shim PID 是谁？ |
| 待打开文件 | `src/runtime/pkg/containerd-shim-v2/create.go` |
| 未闭合问题 | （下场结束后填写） |

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-04 | 初版：读代码协议 + 必考清单落仓；轨道全未开始 |
