# 知识图谱（L3）

索引约定见 `docs/superpowers/specs/2026-07-23-l3-roadmap-and-notes-design.md`。  
状态：`未测` / `会` / `半会` / `不会` — 以摸底、清单、模拟分为准。

口令：训练中暴露不会 → 写 `notes/`；复盘看本表。

## A 主图谱（目标岗）

| 域 | 维 | 知识点 | 状态 | 笔记 / 错题 |
|----|----|--------|------|-------------|
| 容器/K8s 基础 | C1 | Pod/Deploy/Svc、探针、QoS、滚动更新 | 未测 | `01-round1/` |
| 排障与可观测 | C2 | CrashLoop/OOM/NotReady 路径、监控告警 | 未测 | |
| 混部/cgroup/CSI | C3 | 混部干扰与隔离、cgroup、CSI 部署坑 | 未测（经历强，口述待测） | 故事卡 |
| Go 基础 | G1 | slice/append | 半会 | GO-D-01 |
| Go 基础 | G1 | map 并发 | 会 | GO-D-02 |
| Go 基础 | G1 | error / `%w` / Is/As | 不会 | [笔记](../notes/A-target/go-error-wrapping.md) · GO-D-03 |
| Go 基础 | G1 | interface nil | 半会 | [笔记](../notes/A-target/go-interface-nil.md) · GO-D-04 |
| Go 基础 | G1 | defer | 半会 | GO-D-05 |
| Go 并发 | G2 | goroutine 泄漏 | 半会 | [笔记](../notes/A-target/go-goroutine-leak.md) · GO-D-06 |
| Go 并发 | G2 | channel | 不会 | GO-D-07（待笔记） |
| Go 并发 | G2 | context | 不会 | GO-D-08（待笔记） |
| Go 并发 | G2 | 超时取消并发计数 | 半会 | GO-D-10 |
| 云原生 Go | G3 | 事件自动处置防风暴 | 半会 | GO-D-09 |
| 编码过线 | X1 | 小练习次数 | 未测 | `06-golang/05-coding/` |
| 表达 | X2 | 四段式 / 排障 / STAR | 进行中 | `ANSWERING.md` |

## B 薄册（够用）

| 册 | 知识点 | 状态 | 笔记 |
|----|--------|------|------|
| OS | namespace / cgroup 与容器对应 | 未测（实践强，概念口述待测） | 待写 `notes/B-thin/` |
| 网络 | TCP/DNS + Service/CNI 现象排查 | 未测（弱项已标） | 待写 |
| 算法 | 数组/哈希/字符串 + 并发过线题 | 未测 | 待写 |
| 数据库 | 默认不开 | — | 雷达连续高频再议 |

## 观察维（未加权，见 ASSESSMENT）

市场或训练中反复出现、但尚未进八维加权的能力，记在 `ASSESSMENT.md`「观察维」；满样本再议是否升级。
