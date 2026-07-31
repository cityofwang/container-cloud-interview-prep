# 接入新的 GitHub 项目（与助手沟通规范）

> 目标：每个外部项目都变成 `07-projects/<slug>/` 下**可离线复习**的学习包，并与面试仓 `KNOWLEDGE-MAP` / `STORY-CARDS` 挂钩。

## 你需要提供什么

| 字段 | 必填 | 说明 |
|------|------|------|
| 项目标识 | ✅ | GitHub URL、`<org>/<repo>` 或本地 clone 路径 |
| 你的角色 | ✅ | 例如：读源码、写对接服务、生产运维、仅面试了解 |
| 学习目标 | ✅ | `面试深挖` / `落地服务` / `两者` |
| 版本/分支 | 建议 | 如 `v3.0.0`、`main` |
| 本地路径 | 建议 | 有 clone 时助手可读源码落 `sources.md` |
| 优先关心 | 可选 | 如「监控」「网络」「调度」 |
| 关联故事 | 可选 | 是否要写新 STORY-CARD |

## 助手会做什么（标准流水线）

```text
1. 识别项目
   ├─ 读 README / docs / architecture 设计稿
   ├─ 有本地路径 → 扫目录与入口（只摘索引，正文仍自包含）
   └─ 无本地 → Web/GitHub 公开文档（能力边界会说明）

2. 产出骨架
   ├─ cp _TEMPLATE/ → 07-projects/<slug>/
   ├─ PROJECT.md（元信息 + 学习状态）
   ├─ KNOWLEDGE-INDEX.md（P0/P1/P2 知识点 + 章节映射）
   └─ sources.md（可选路径索引）

3. 写 MVP（通常 2 章）
   ├─ 00-one-pager.md（架构一页纸）
   └─ 与你目标最相关的一章（如 observability / control-plane）

4. 挂接面试仓
   ├─ KNOWLEDGE-MAP 加「项目挂钩」列或脚注
   ├─ 需要时草稿 STORY-CARDS
   └─ COMMANDS 已有口令可直接用

5. 给训练建议（书面，写入 PROJECT.md 或 L3-plan 备注）
   ├─ 建议周次 / 与 FZ 关系（默认不打乱 FZ）
   ├─ 每章预计时长
   └─ 自测过关标准
```

## 你怎么开口（模板）

### A. 全新项目

```text
新项目 onboarding
- 项目：https://github.com/containerd/containerd
- 我的角色：读源码 + 可能写节点 Agent
- 目标：两者
- 版本：v2.0
- 本地 clone：~/Projects/containerd
- 优先：CRI Task API、metrics、cgroup
```

### B. 已有项目加一章

```text
项目加章 kata 04-network-tcfilter-tap
- 背景：FZ1 CNI 半会，想结合 Kata 网络加深
- 时间：周末 1h
```

### C. 只要训练规划、暂不写文档

```text
项目规划-only
- 项目：prometheus/prometheus
- 目标：面试可讲存储与抓取路径
- 时间：2 个周末各 2h
- 请先出 KNOWLEDGE-INDEX 草案和排期，确认后再落仓
```

### D. 本地已有深度对话、迁移进仓

```text
项目迁移
- 把本次 Chat 关于 kata 的 K01–K12 整理进 07-projects/kata-containers/
- 章节：01-isolation-and-cgroup
```

## 助手**不会**默认做的事

- ❌ 不打乱当前 FZ 主线（除非你明确 `切换专注区` 或插队）
- ❌ 不把 `.understand-anything/` 当进度权威
- ❌ 不编造你的生产经历（故事卡只写你确认的）
- ❌ 不替代 `notes/` 里已有通用知识点（只互链）

## 识别项目的边界

| 情况 | 做法 |
|------|------|
| 公开 GitHub + 文档全 | 在线识别 + 本地学习包 |
| 私有仓库 | 你提供 clone 路径或粘贴 README/架构图 |
| 超大 monorepo | 先定 **子系统边界**（如只学 `src/runtime`） |
| 纯文档/无代码 | 按「概念项目」建包，sources 标 N/A |

## 训练规划写在哪

| 粒度 | 位置 |
|------|------|
| 单项目周计划 | `<slug>/PROJECT.md` § 学习排期 |
| 与 L3/FZ 关系 | `review/roadmap/L3-plan.md` 备注或 P 轨小节 |
| 知识点掌握度 | `<slug>/KNOWLEDGE-INDEX.md` 状态列 |
| 场末快照 | `CONTINUITY.md`（若本场练了项目） |

## 过关标准（单章）

- 闭卷口述 **结论背板** ≥ 1 分钟  
- **自测题** ≥ 80% 先答后讲过关  
- 能答 **1 组对比 + 1 个坑**  
- `KNOWLEDGE-INDEX` 对应项标 `会` 或 `半会`

## 示例：kata-containers

已落地：`07-projects/kata-containers/`  
下一章建议：`01-isolation-and-cgroup`（挂 FZ5 / S2）
