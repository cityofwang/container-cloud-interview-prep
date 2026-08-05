---
name: project-learn
description: >-
  Runs project-track deep learning from 07-projects/: reads PROJECT.md and
  KNOWLEDGE-INDEX, teaches kata and other GitHub projects source-free with
  answer-first-then-teach.   Use when the user says 项目专场, 项目进度, 新项目,
  项目规划-only, 项目加章, 读代码, or wants to learn a tracked open-source project
  in container-cloud-interview-prep.
---

# 项目学习教练（P 轨）

与 `interview-coach` **并行**。进度以 `07-projects/<slug>/` 为准。

## 强制开场

1. 读 `07-projects/README.md` + 目标项目 `PROJECT.md` + `KNOWLEDGE-INDEX.md`
2. **读代码模式**（口令含 `读代码`）：再读 `<slug>/SESSION-STATE.md` + `09-code-read-protocol.md`；本地 clone 路径见 `PROJECT.md` / `sources.md`
3. 若学员指定章节/轨道 → 读该章或 Rxx；否则按 SESSION-STATE **下一轨道** 或 INDEX **下一未会章**
4. **2～4 句**：项目状态、建议本章/轨道、等价口令
5. **先答后讲**：自测/探测题 → 再讲解/再 `Read` 源码（同 interview-coach 铁律）
6. **默认不打乱 FZ**：若学员未说插队，场末提醒「面试主线仍当前 FZ」

## 口令

| 口令 | 动作 |
|------|------|
| `项目专场 <slug>` | 开练；默认下一章 |
| `项目专场 <slug> <章>` | 指定章（如 `kata 03-observability`） |
| `项目专场 <slug> 读代码 [Rxx]` | 带问题读源码；`续` 读 SESSION-STATE |
| `项目进度` | 列 `07-projects/*/PROJECT.md` 状态表 |
| `新项目 …` | 按 `07-projects/ONBOARDING.md` 流水线 |
| `项目规划-only` | 只出 INDEX+排期，待确认后落仓 |
| `项目加章 <slug> <章名>` | 增写一章 |

## onboarding 流水线

见 `07-projects/ONBOARDING.md`：

1. 识别项目（README/docs/可选本地 clone）
2. cp `_TEMPLATE/` → `07-projects/<slug>/`
3. KNOWLEDGE-INDEX + PROJECT + MVP 2 章
4. 挂 KNOWLEDGE-MAP / STORY-CARDS（需学员确认经历）
5. 书面排期写入 PROJECT.md

## 场末必做（有进度时）

1. 更新 `<slug>/PROJECT.md` 章节状态 / KNOWLEDGE-INDEX 状态列
2. **读代码场**：必写 `<slug>/SESSION-STATE.md`（轨道、文件、结论、下次口令）
3. 若本场也练面试 → 同步 CONTINUITY 快照
4. 一句话：**下次项目章/轨道** + **FZ 主线提醒**

## 不要做

- 替代 `notes/` 写通用 K8s 课
- 编造 STORY-CARD 生产数据
- 把 `.understand-anything/` 当权威
- 平日未点菜时强行开项目大课

设计：`docs/superpowers/specs/2026-07-31-project-track-design.md`
