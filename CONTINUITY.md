# 续聊一页纸（新对话先读我）

> 上下文满了就开新聊天。进度以本仓库为准，不依赖旧对话记忆。  
> 每次训练结束：更新本文件「当前快照」+ `README` 进度板 + 错题本/评估/L3 排期（如有变更）。

## 稳定性与准确性（铁律）

助手在新对话中必须遵守：

1. **请严格按 `CONTINUITY.md` 与 `docs/superpowers/specs/` 下已确认设计执行。**  
2. 打分、过关、周末/平日时间盒、错题回炉、岗位雷达、能力档 L1–L5、进阶锁定、国内题源、合面配比、L3 路线 —— 一律以仓库文件为准，不以「好像聊过」为准。  
3. 不确定学员进度时：先读本文件快照，再按需读下方「新对话必读」列表，再开口令对应动作。  
4. 不编造经历、不擅自解锁 E1–E5、不一次堆全量新题、不把平日变成大课。  
5. 若与学员口头新约定冲突：先问一句确认，再改仓库（改完才算生效）。  
6. **不**把 `.understand-anything/`（代码理解插件缓存）当训练进度；续聊不依赖它。

## 新对话开场（复制发给助手）

```text
继续容器云+Go面试训练。仓库：container-cloud-interview-prep。
请严格按 CONTINUITY.md 与 docs/superpowers/specs/ 下已确认设计执行。
请先读 CONTINUITY.md，再按需要读 README.md、00-profile/ASSESSMENT.md、
review/wrong-book.md、review/roadmap/L3-plan.md、06-golang/00-diagnostic/RESULT.md。
今天口令：<周末开练 | 开始 Go 摸底 | 错题回炉 | 我有空 30分钟 | …>
```

若助手跑偏，单独再发一句：

```text
请严格按 CONTINUITY.md 与 docs/superpowers/specs/ 下已确认设计执行。
```

## 新对话必读（按优先级）

| 顺序 | 文件 | 用途 |
|------|------|------|
| 1 | 本文件快照 | 阶段、下一步口令 |
| 2 | `README.md` 进度板 | 面次/摸底/错题计数 |
| 3 | `review/roadmap/L3-plan.md` | P0–P3、预计达标窗 |
| 4 | `review/wrong-book.md` | 未巩固错题 |
| 5 | `00-profile/ASSESSMENT.md` | 八维 + 观察维 O1–O7 |
| 6 | `06-golang/00-diagnostic/RESULT.md` | 摸底是否定稿 |
| 按需 | `00-profile/KNOWLEDGE-MAP.md`、`notes/` | 图谱与详解笔记 |
| 按需 | 已确认 specs（见下） | 规则冲突时以 spec 为准 |

**已确认设计（勿无视）：**  
`2026-07-21` 容器云主设计 · `2026-07-22` Go 双轨 / 评估解锁 / 错题与雷达 / 周末排期 · **`2026-07-23-l3-roadmap-and-notes-design.md`（L3 路线+A/B 笔记，已通过）**

## 我们在干什么

- 岗位：容器云 / 云原生为主，Go 双轨（云原生 Go 主 + 业务后端辅）；策略 D 广覆盖，优先 A 大厂混部/容器云
- **长期目标分层**：L3 → L4 → Offer；**当前只执行 L3**（L4/谈薪细排期未开）
- **L3 粗估窗口**：约 8～16 周（见 `L3-plan.md`，动态改期）
- 知识：`KNOWLEDGE-MAP` = **A 主图谱**（岗）+ **B 薄册**（OS/网络/算法够用；DB 默认不开）
- 笔记：`notes/` 从不会/半会增量写详解；不替代错题复现得分
- 时间：平日只错题（≤30min）；周末约 3～4h（`周末开练`）；碎片用 `我有空 30分钟`
- 作答：四段式，见 `00-profile/ANSWERING.md`
- 学员：约 6 年，托管 K8s 运维向；强项混部/cgroup/事件/CSI/监控；Go 约 A～B，摸底进行中
- **观察维 O1–O7**（错题清除速率、变更回滚、值班沟通、多集群、笔记→闭卷、故事追问深度、合面耐力）：学员已确认合理，**记账不加权**；升级需明确口令

## 当前快照（练完就改）

| 项 | 值 |
|----|-----|
| 更新日期 | 2026-07-23 |
| 能力档 | 未评估（G1/G2 暂 2） |
| 建议包类型 | D（先完成 Go 摸底） |
| L3 阶段 | **P0 摸底收口**（`review/roadmap/L3-plan.md`） |
| 预计 L3 窗口 | 2026-09-22～2026-11-12（偏后半更稳） |
| Go 摸底 | 进行中：自评完；对练完 03/04/06；**下一切口 GO-D-07→08→09/10** |
| 容器一面 | 题库已就绪，待开卷 |
| 错题未巩固 | 9（GO-D-01/03/04/05/06/07/08/09/10） |
| 学习笔记 | 已开三篇：error / interface-nil / goroutine-leak |
| 观察维 | O1–O7 已登记，不加权 |
| 进阶 E1–E5 | 全部锁定 |
| 下一步首选口令 | `我有空 30分钟` / `开始 Go 摸底`（续 **07**）或 `错题回炉`（优先 03/04/06+笔记） |

## 助手续聊时必做

1. 读本文件快照，勿假设旧聊天里的口头约定  
2. 按口令执行；周末包写入 `review/weekend/YYYY-MM-DD-plan.md`  
3. 不会的题入库 `review/wrong-book.md`；摸底进展写 `RESULT.md` / `CHECKLIST.md`；相关维更新 `ASSESSMENT.md`  
4. 暴露「不会/半会」且值得沉淀 → 增量写 `notes/`，并回链 `KNOWLEDGE-MAP.md`  
5. 训练结束更新：本快照 + `README` 进度板 + **`L3-plan.md` 阶段/窗口（若有改期）**  
6. 不编造学员没做过的项目；不主动展开未解锁进阶（谈薪/压力面等）  
7. 打分与评价必须对照量尺与评估 spec，避免随口打分  
8. 观察维只记账；不得擅自改八维权重或 L3 门槛（除非学员 `按雷达校准评估` 等确认）

## 关键路径

| 用途 | 路径 |
|------|------|
| 进度/口令 | `README.md` |
| 评估 + 观察维 | `00-profile/ASSESSMENT.md` |
| 知识图谱 | `00-profile/KNOWLEDGE-MAP.md` |
| L3 排期 | `review/roadmap/L3-plan.md` |
| 学习笔记 | `notes/`（`A-target/` 主；`B-thin/` 薄册） |
| 错题 | `review/wrong-book.md` |
| Go 摸底 | `06-golang/00-diagnostic/` |
| 容器一面 | `01-round1/` |
| 周末说明 | `review/weekend/README.md` |
| L3 设计 | `docs/superpowers/specs/2026-07-23-l3-roadmap-and-notes-design.md` |
| 设计总览 | `docs/superpowers/specs/` |
