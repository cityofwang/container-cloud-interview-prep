# P 轨：项目学习系统

**定位：** 与面试主线（FZ1–FZ6）**平行**的选修轨。沉淀「接触过的开源/工作项目」的**脱离源码**学习包，服务深度理解与面试深挖。

**不替代：**

| 模块 | 职责 |
|------|------|
| `notes/` | 横切知识点（Service、探针、cgroup…） |
| `STORY-CARDS.md` | STAR 经历（你**做过什么**） |
| **P 轨 `07-projects/`** | 系统 mastery（你**搞懂了什么**） |

## 怎么用

| 场景 | 做法 |
|------|------|
| 周末加 1h 深度 | `项目专场 kata` 或 `项目专场 kata K03` |
| 看进度 | `项目进度` |
| 新开 GitHub 项目 | `新项目 <slug>`（见下方「接入新项目」） |
| 合面前 | 读 `interview-hooks.md`，更新 `STORY-CARDS` |

**节奏约定（默认）：**

- **平日 ≤30min**：仍走当前 FZ 错题，**不**默认开项目新课
- **周末**：可在 FZ 包后加 1h `项目专场`
- **仍遵守先答后讲**（与 `interview-coach` 一致）

## 目录

```text
07-projects/
├── README.md                 # 本文件
├── ONBOARDING.md             # 如何接入新的 GitHub 项目（与助手沟通规范）
├── _TEMPLATE/                # 复制开新项目
└── kata-containers/          # 第一个项目（进行中）
```

## 单项目标准结构

| 文件 | 用途 |
|------|------|
| `PROJECT.md` | 元信息、学习状态、角色、版本 |
| `KNOWLEDGE-INDEX.md` | 知识点清单 ↔ 章节 ↔ KNOWLEDGE-MAP |
| `00-one-pager.md` | 一页架构（无源码可读） |
| `NN-*.md` | 分章深讲 |
| `pitfalls.md` | 常见坑汇总 |
| `interview-hooks.md` | 挂故事卡 / 面试追问 |
| `sources.md` | 可选：repo、commit、关键路径索引 |
| `quizzes/` | 自测题 |
| `08-rd-exam-checklist.md` | 研发必考/必坑（可选） |
| `09-code-read-protocol.md` | 带问题读源码轨道 Rxx（可选） |
| `SESSION-STATE.md` | **跨 Chat 进度**；新对话读此续学 |

## 章节单篇结构

1. 结论背板（30 秒）  
2. 原理（机制 + 控制/数据面）  
3. 使用场景  
4. 对比（至少一组）  
5. 常见坑  
6. 面试挂钩  
7. 自测（先答后讲）  
8. 关联（KNOWLEDGE-MAP / notes / sources）

## 接入新项目

完整流程见 [`ONBOARDING.md`](ONBOARDING.md)。

**你对助手说（复制改填）：**

```text
新项目 onboarding
- 项目：<GitHub URL 或 slug>
- 我的角色：<读源码 / 对接 / 生产运维>
- 目标：<面试深挖 / 落地服务 / 两者>
- 本地 clone：<有/无，路径>
- 优先章节：<可选>
```

助手会：扫 README/docs → 出 `KNOWLEDGE-INDEX` 草案 → 写 `PROJECT.md` + MVP 章节 → 挂 `KNOWLEDGE-MAP` → 给学习排期建议（**不打乱当前 FZ**）。

## 当前项目

| 项目 | 状态 | 下一章 |
|------|------|--------|
| [kata-containers](kata-containers/PROJECT.md) | 进行中 · MVP | `01-isolation-and-cgroup` |

## Skill

- 面试主线：`.cursor/skills/interview-coach`
- 项目深学：`.cursor/skills/project-learn`（口令 `项目专场` / `项目进度`）

设计说明：`docs/superpowers/specs/2026-07-31-project-track-design.md`
