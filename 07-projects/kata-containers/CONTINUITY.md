# Kata 跨 Chat 续聊指南

> **问题：** 在别的 Chat 里聊的是 Calico / K8s / 别的项目，怎么「唤醒」Kata 这段记忆？  
> **答案：** Cursor **不会**自动继承对话；靠 **本目录落盘文件 + 固定口令** 让助手主动加载上下文。

---

## 最快唤醒（复制到任意新 Chat）

```text
项目专场 kata 读代码 续
仓库：~/Projects/container-cloud-interview-prep/07-projects/kata-containers
源码：~/wangfanDoc/GoDemo/src/kata-containers（3.0.0）
请先读 CONTINUITY.md → SESSION-STATE.md → 09-code-read-protocol.md，再按「下次口令」继续。
环境：K8s 1.17/1.21 · CLH · containerd · 节点 Agent（Stats/Update，不直连 vsock）
```

**指定轨道（例如接着 Stats 源码）：**

```text
项目专场 kata 读代码 R04
```

**只复习全局地图、不读代码：**

```text
项目专场 kata 复习
请读 KNOWLEDGE-MAP.md + LEARNING-8W.md，帮我做本周计划。
```

**复习某域（例如内存+cgroup 已聊透的部分）：**

```text
项目专场 kata 域复习 memory-cgroup
请读 domains/03-memory-cgroup.md + SESSION-STATE 对话沉淀。
```

---

## 文件优先级（助手应按序读）

| 顺序 | 文件 | 用途 |
|------|------|------|
| 1 | **`CONTINUITY.md`** | 本文件：怎么续、口令表 |
| 2 | **`SESSION-STATE.md`** | 进度、轨道、25+ 条对话沉淀、下次从哪继续 |
| 3 | **`09-code-read-protocol.md`** | R01–R08 带读协议 |
| 4 | **`KNOWLEDGE-MAP.md`** | 28 知识域全景（全仓扫描版） |
| 5 | **`LEARNING-8W.md`** | 8 周排期 + 验收 |
| 6 | **`SOURCE-TRAIL.md`** | Stats/Update/E2E 源码路线 |
| 7 | **`GAPS.md`** | 聊过 vs 未聊 |
| 8 | **`domains/*.md`** | 分域笔记 |
| 9 | **`pitfalls.md`** | 坑索引 |

可选：`PROJECT.md`（项目元数据）、`KNOWLEDGE-INDEX.md`（K01–Kxx 状态）。

---

## 口令表

| 口令 | 行为 |
|------|------|
| `项目专场 kata 读代码 续` | 读 SESSION-STATE → 从「下次口令」轨道继续 |
| `项目专场 kata 读代码 R04` | 强制 R04 Stats 全链 |
| `项目专场 kata 读代码 R05` | Update + updateResources |
| `项目专场 kata 读代码 R06` | 网络 |
| `项目专场 kata 复习` | 全局地图 + 自测，不强制开源码 |
| `项目专场 kata 域复习 <name>` | 读 `domains/` 下对应文件 |
| `项目专场 kata 模拟面试` | 读 `MOCK-INTERVIEW-40.md` 抽题 |

---

## 2026-08-07 本轮新增沉淀（内存 / cgroup / KVM）

> 已写入 `domains/03-memory-cgroup.md` 与 `SESSION-STATE.md`，新 Chat **可直接当已知**。

1. **Pod cgroup limit** = Σ container limit + RuntimeClass overhead（kubelet）；**不含** default_memory。
2. **VM 目标** = default_memory + Σ limit（Kata updateResources）；与 pod limit **两套账**。
3. **false 模式**：pod cur ≈ vCPU；**kata_overhead cur** ≈ CLH(default+Σlimit)+shim；overhead **无 limit**。
4. **true 模式**：全家桶受 pod limit；overhead 须 ≥ default_memory + 余量，否则热插后 OOM。
5. **default_memory** 默认 2048 MiB，不配也有；**不会**为 VM 基线单独热插，只跟容器 limit 热插。
6. **CLH + KVM**：Guest GPA 连续，Host HPA 离散；mmap + KVM memory region + EPT。
7. **全局学习地图**：见 `KNOWLEDGE-MAP.md`（28 域），不只内存/cgroup。

---

## 与别的项目 Chat 并行时

| 你在聊 | Kata 进度怎么保 |
|--------|----------------|
| Calico / 网络 FZ | Kata 文件仍在仓里；说「今天只 kata 30min R04」即可 |
| 换机器 | clone `container-cloud-interview-prep`，口令不变 |
| 长间隔后回来 | 先 `项目专场 kata 复习` 10min，再 `读代码 Rxx` |

**原则：** 进度以 **`SESSION-STATE.md` 的「变更日志」** 为准，不以 Chat 记忆为准。

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-07 | 初版：全仓 KNOWLEDGE-MAP + 8W 排期 + domains + 唤醒口令 |
