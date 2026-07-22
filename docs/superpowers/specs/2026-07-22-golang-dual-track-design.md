# 云原生 Go 双轨训练设计

- 日期：2026-07-22
- 状态：已确认；实现见 plans/2026-07-22-golang-dual-track-review-infra.md
- 仓库：`~/Projects/container-cloud-interview-prep`
- 关联：在既有容器云面次闯关之上，增加 Golang 双轨 + 合面模拟
- 配套增强：`docs/superpowers/specs/2026-07-22-spaced-review-and-china-sources-design.md`（错题遗忘曲线复现 + 国内真实题源；全仓共用）

## 1. 背景与目标

学员补充信息：

- 工作语言以 **Golang** 为主
- Go 水平自我评估在 **A～B 之间**（能写运维脚本/小工具；并发用过但不系统），并希望先 **摸底（D）**
- 目标岗位策略：**C** = 云原生/平台 Go 为主，业务后端 Go 为辅
- 与容器线关系：**并行刷题（A）** + **模拟按云原生 Go 合面（D）**

既有约束（继承容器云设计，仍有效）：

- 总策略 D（广覆盖）+ 优先 A（大厂容器云/混部）
- 面次闯关；不一次堆全量题库；不编造未做过的项目
- 编码过线，不按算法岗刷题

成功标准：

- 完成一次 Go 摸底并产出推荐学习顺序
- 形成可并行刷的 `06-golang/` 题库骨架与摸底包
- 一面起能进行「容器 + Go」合面模拟
- 编码旁线以 Go 小练习为主

## 2. 方案选择

采用 **方案 1：双轨题库 + 合面模拟**。

- 容器线：`01-round1` … `04-round4` 保留，不推倒
- Go 线：新建 `06-golang/`，分节推进
- 模拟：按合面出题（例一面 6 容器 + 4 Go）
- 编码：`06-golang/05-coding/` 为主；原 `05-coding-line/` 保留（含已有 C-01）

不采用：仅旁线分场模拟（方案 2）；整仓揉成单一合面文件（方案 3）。

## 3. 仓库结构（新增）

```
06-golang/
├── 00-diagnostic/     # 摸底题 + RESULT.md
├── 01-basics/         # 语法/接口/error/常见坑
├── 02-concurrency/    # goroutine/channel/select/context/GMP 口述
├── 03-cloudnative/    # client-go、informer、简单 controller 思路
├── 04-backend-lite/   # Gin/gRPC 点到、DB、接口设计（辅）
├── 05-coding/         # Go 过线小练习
└── mocks/             # Go 单科模拟记录（可选）
```

`README.md` 进度板新增字段：

- Go 摸底状态
- Go 当前小节
- 合面模拟次数
- 编码练习次数（以 Go 为主计数）

## 4. 摸底与各节范围

### 摸底（约 45 分钟，先做）

- 口述约 8～10 题：slice/map、error、interface 空值、goroutine 泄漏直觉、channel、context 等
- 现场 1 道小 Go 题（并发计数或超时取消类）
- 产出：`06-golang/00-diagnostic/RESULT.md`（会/半会/不会 + 推荐先学哪一节）

### 01-basics

类型、接口、error、defer、常见坑；一面过线。

### 02-concurrency

GMP 面试口述版、channel/select、context、竞态与泄漏；一二面核心。

### 03-cloudnative

client-go 用法直觉、List-Watch/informer 概念、事件驱动服务怎么写；挂钩学员已有事件逻辑/工具经历，不编造大型 Operator 项目。

### 04-backend-lite（辅）

HTTP/Gin 或标准库、gRPC 点到为止、DB 连接与事务口述；够业务后端辅线即可。

### 05-coding

每周 1～2 道：并发小题、字符串/哈希、简单限流或 worker pool；过线目标。

## 5. 合面配比

| 面次 | 容器 | Go | 说明 |
|------|------|-----|------|
| 一面 | ~60% | ~40% | 基础对象 + Go 基础/简单并发 |
| 二面 | ~50% | ~50% | 排障/混部 + 并发深挖/小编码 |
| 三面 | ~40% | ~60% | 架构判断 + 云原生 Go 设计题 |
| 四面 | 综合故事 | 动机/协作 | 强调容器运维 + Go 工程双背景 |

合面打分仍用既有 1–5 分与三维度总分；统计时区分容器题 / Go 题均分。

## 6. 过关与和容器线的关系

- 容器 `01-round1` 继续有效；合面模拟前至少完成一次 Go 摸底
- Go 节级过关：会+半会 ≥ 80%，不会项有口述补稿
- 合面：Go 相关题均分 ≥ 3.5 且无硬伤；容器侧沿用原过关标准
- **合面该「面」过关** = 容器与 Go 两侧均达线
- 原编码进三面前 ≥3 次：改为以 Go 练习次数为主（Shell C-01 可计 1 次）

## 7. 启动顺序（实现阶段）

1. 更新 README 进度板字段与本 spec
2. 落 `06-golang/` 骨架
3. 落摸底题包（约 8～10 题 + 1 道代码）与 RESULT 模板
4. 学员完成摸底 → 填写 RESULT → 推荐学习顺序
5. 按推荐开 basics 或 concurrency 第一批；同时可继续容器一面
6. 两边开卷比例足够后 → 第一次合面模拟（一面）

## 8. 首期明确不做

- 完整业务系统项目脚手架
- 中间件源码级深挖（如 etcd Raft），除非摸底显示明显偏强
- 一次性堆大规模 Go 题海（如 200 题）

## 9. 错题复现与题源（继承全仓增强 spec）

- 摸底「不会/半会」与模拟低分题写入 `review/wrong-book.md`
- 合面额外抽 2～4 道错题复现；满 3/7 天无模拟则开 `错题回炉`
- 新题遵守国内真实题源规则（ACK/混部/大厂 Go 高频等）

详见：`2026-07-22-spaced-review-and-china-sources-design.md`

## 10. 范围确认

已确认：

- 岗位：C（云原生 Go 主 + 业务后端辅）
- 水平：A～B + 先摸底
- 节奏：并行 A + 合面 D
- 落地：方案 1（双轨题库 + 合面模拟）
- 错题：混合复现 C；题源：国内真实面试场景
- 招聘雷达：每周定期 + `扫岗位` 按需（见 spaced-review spec §5）
- 能力评估与进阶解锁：见 `2026-07-22-assessment-and-unlock-gates-design.md`（L3 前不加谈薪/故事等进阶）
