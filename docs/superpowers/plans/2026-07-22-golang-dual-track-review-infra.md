# Go Dual-Track + Review Infrastructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land the confirmed specs: Go dual-track skeleton + diagnostic pack, wrong-book, job-market radar folder, assessment template with locked advanced modules, README/口令 updates, and structure-check coverage — so the learner can start Go摸底 and use 错题/雷达/评估口令.

**Architecture:** Markdown-only training kit extension. Keep existing `01-round1` intact. Add `06-golang/`, `review/`, and `00-profile/ASSESSMENT.md`. Advanced modules E1–E5 stay locked (docs only). No full basics/concurrency banks in this plan — only diagnostic + placeholders.

**Tech Stack:** Markdown, bash `scripts/check-structure.sh`, git.

## Global Constraints

- Specs (confirmed): `2026-07-22-golang-dual-track-design.md`, `2026-07-22-spaced-review-and-china-sources-design.md`, `2026-07-22-assessment-and-unlock-gates-design.md`
- Dual track + 合面; Go 云原生主 + 业务辅; 先摸底
- 错题混合复现 C; 国内真实题源; 招聘雷达 D（周 + `扫岗位`）
- 进阶 E1–E5 锁定至 L3/L4; 评估可随雷达校准但须学员确认
- 不编造项目经历; 不一次堆全量 Go 题; 编码过线非算法岗
- 国内题感：ACK/混部/事件运维/大厂 Go 高频（GMP、channel、context 等）
- 作答引导：四段式/排障路径/STAR — 写入 README 或 `00-profile/ANSWERING.md`
- Do not commit unless execution workflow expects it / user asked; prefer commits per task when executing the plan

---

## File Structure

| Path | Responsibility |
|------|----------------|
| `README.md` | Progress board + 口令（含 Go/错题/雷达/评估） |
| `00-profile/ANSWERING.md` | 作答写法（四段式等） |
| `00-profile/ASSESSMENT.md` | 八维 + L 档 + 锁定进阶 + 标准版本 |
| `review/wrong-book.md` | 错题本模板 |
| `review/job-market/README.md` | 雷达操作说明 |
| `review/job-market/.gitkeep` | 保证目录存在（扫描报告后写） |
| `06-golang/00-diagnostic/QUESTIONS.md` | 摸底 9 口述 + 1 代码 |
| `06-golang/00-diagnostic/RESULT.md` | 摸底结果模板 |
| `06-golang/00-diagnostic/CHECKLIST.md` | 会/半会/不会 |
| `06-golang/01-basics/README.md` … `04-backend-lite/README.md` | 锁定/待开占位 |
| `06-golang/05-coding/README.md` + `G-01-timeout-counter.md` | Go 编码线 |
| `06-golang/mocks/TEMPLATE.md` | Go 单科模拟模板（可选） |
| `docs/superpowers/plans/HANDOFF-GO-DIAGNOSTIC.md` | 开练交接 |
| `scripts/check-structure.sh` | 扩展必有文件列表 |

---

### Task 1: README + answering guide + profile assessment stub

**Files:**
- Modify: `README.md`
- Create: `00-profile/ANSWERING.md`
- Create: `00-profile/ASSESSMENT.md`

**Interfaces:**
- Consumes: assessment dimensions C1–X2, L1–L5, E1–E5 locked from assessment spec
- Produces: progress fields `Go摸底` / `Go当前小节` / `合面次数` / `错题未巩固` / `能力档` / `最近岗位雷达` / `标准版本`

- [ ] **Step 1: Rewrite `README.md` progress + 口令**（保留原容器进度，追加 Go/评估字段）

进度板至少含：

| 项 | 状态 |
|----|------|
| 当前面次 | 一面（题库已就绪，待开卷） |
| 一面过关 | 未开始 |
| Go 摸底 | 未开始 |
| Go 当前小节 | （摸底后填写） |
| 合面模拟次数 | 0 |
| 编码练习次数（Go 为主） | 0 / 进三面前需 ≥3 |
| 错题未巩固 | 0 |
| 能力档 | 未评估 |
| 进阶解锁 | 全部锁定（E1–E5） |
| 最近岗位雷达 | 无 |
| 评估标准版本 | 2026-07-22-v1 |

口令增加：`开始 Go 摸底` / `错题回炉` / `看错题本` / `扫岗位` / `看岗位雷达` / `能力评估` / `按雷达校准评估`

- [ ] **Step 2: Write `00-profile/ANSWERING.md`** with 四段式、排障路径、STAR、编码作答、训练时怎么写（会/半会/不会）

- [ ] **Step 3: Write `00-profile/ASSESSMENT.md`**

```markdown
# 能力评估

- 标准版本：`2026-07-22-v1`
- 最近校准：无（初始）
- 当前档：未评估（完成 Go 摸底或合面后更新）
- 进阶解锁：E1–E5 全部锁定

## 维度（1–5，n/a=尚未测）

| 维 | 名称 | 分 | 权重 |
|----|------|----|------|
| C1 | 容器/K8s 基础运维 | n/a | 20% |
| C2 | 生产排障与可观测 | n/a | 15% |
| C3 | 混部/cgroup/CSI | n/a | 15% |
| G1 | Go 语言基础 | n/a | 10% |
| G2 | Go 并发 | n/a | 15% |
| G3 | 云原生 Go | n/a | 10% |
| X1 | 编码过线 | n/a | 10% |
| X2 | 结构化表达 | n/a | 5% |

## 距下一档

（摸底后填写）

## 变更日志

| 版本 | 日期 | 说明 |
|------|------|------|
| 2026-07-22-v1 | 2026-07-22 | 初始标准 |
```

- [ ] **Step 4: Verify files exist**

Run: `test -f 00-profile/ANSWERING.md && test -f 00-profile/ASSESSMENT.md && echo OK`  
Expected: `OK`

- [ ] **Step 5: Commit**（执行计划时）

```bash
git add README.md 00-profile/ANSWERING.md 00-profile/ASSESSMENT.md
git commit -m "Add answering guide, assessment stub, and README progress fields."
```

---

### Task 2: Wrong-book + job-market radar skeleton

**Files:**
- Create: `review/wrong-book.md`
- Create: `review/job-market/README.md`

**Interfaces:**
- Consumes: wrong-book fields from spaced-review spec §2.1; radar report sections §5.3 including 评估校准建议
- Produces: empty wrong-book table; radar ops doc with 口令与报告模板标题列表

- [ ] **Step 1: Write `review/wrong-book.md`**

表头列：`id | 来源 | 首次错因 | 首次日期 | 复现计划 | 复现结果 | 状态(未巩固/已巩固)`  
加简短入库规则摘要（不会/≤2 分必入等）。

- [ ] **Step 2: Write `review/job-market/README.md`**

说明：每周 + `扫岗位`；匹配关键词（容器云/ACK/混部/Go）；报告路径 `YYYY-MM-DD-scan.md`；六节结构含评估校准建议；确认后才补题/校准。

- [ ] **Step 3: Verify**

Run: `test -f review/wrong-book.md && test -f review/job-market/README.md && echo OK`  
Expected: `OK`

- [ ] **Step 4: Commit**

```bash
git add review/wrong-book.md review/job-market/README.md
git commit -m "Add wrong-book and job-market radar skeleton."
```

---

### Task 3: Go track placeholders (basics…backend + mocks)

**Files:**
- Create: `06-golang/01-basics/README.md`
- Create: `06-golang/02-concurrency/README.md`
- Create: `06-golang/03-cloudnative/README.md`
- Create: `06-golang/04-backend-lite/README.md`
- Create: `06-golang/mocks/TEMPLATE.md`

**Interfaces:**
- Consumes: unlock after diagnostic RESULT recommendation
- Produces: placeholders stating 摸底完成后按 RESULT 解锁；勿在本任务写全量题

- [ ] **Step 1: Write four section READMEs** — each states 范围一句话 + `状态：锁定（完成摸底并按 RESULT 推荐后再开题包）`

- [ ] **Step 2: Write `06-golang/mocks/TEMPLATE.md`** — copy structure from `mocks/TEMPLATE.md` but title「Go 单科模拟」；维度同技术深度/表达/岗位匹配

- [ ] **Step 3: Verify four READMEs + template exist**

- [ ] **Step 4: Commit**

```bash
git add 06-golang/01-basics/README.md 06-golang/02-concurrency/README.md 06-golang/03-cloudnative/README.md 06-golang/04-backend-lite/README.md 06-golang/mocks/TEMPLATE.md
git commit -m "Add Go section placeholders and mock template."
```

---

### Task 4: Go diagnostic pack (China-real) + checklist + RESULT

**Files:**
- Create: `06-golang/00-diagnostic/QUESTIONS.md`
- Create: `06-golang/00-diagnostic/CHECKLIST.md`
- Create: `06-golang/00-diagnostic/RESULT.md`

**Interfaces:**
- Consumes: ANSWERING 四段式; story hooks S3 事件
- Produces: IDs `GO-D-01` … `GO-D-09` 口述 + `GO-D-10` 编码；RESULT 填完后驱动下一节

- [ ] **Step 1: Write `06-golang/00-diagnostic/QUESTIONS.md` with the following 10 questions (full text)**

```markdown
# Go 摸底题包

作答用四段式（见 `00-profile/ANSWERING.md`）。先自评再闭卷对练。

## GO-D-01 slice 与底层数组
**题目：** 函数里对 slice append 后，调用方不一定看见新元素，为什么？  
**参考答法要点：** slice 含 ptr/len/cap；传的是头拷贝；append 可能换底层数组；要回传或传指针。  
**追问：** 子切片导致内存泄而不放？  
**挂钩提示：** 无强挂钩则讲清即可  
**题源标签：** 国内高频

## GO-D-02 map 并发
**题目：** 多 goroutine 读写同一 map 会怎样？怎么改？  
**参考答法要点：** 非并发安全，可能 fatal；sync.Mutex 或 sync.Map；少用全局 map。  
**追问：** sync.Map 适合什么读写比？  
**题源标签：** 国内高频

## GO-D-03 error
**题目：** 你怎么做 error 返回？什么时候包装？  
**参考答法要点：** 多返回值；fmt.Errorf %w；errors.Is/As；勿丢弃 error；日志在边界打。  
**追问：** sentinel error 滥用问题？  
**题源标签：** 国内高频

## GO-D-04 interface nil
**题目：** 一个变量是 interface 类型，内部动态值是 nil 指针，和 == nil 比较可能怎样？  
**参考答法要点：** interface 含类型+值；仅值 nil 但类型非 nil 时 interface != nil；返回 error 时常见坑。  
**追问：** 如何正确返回「无 error」？  
**题源标签：** 国内高频

## GO-D-05 defer
**题目：** 多个 defer 顺序？和命名返回值交互你怎么记？  
**参考答法要点：** LIFO；defer 在 return 前；改命名返回值的经典题点到即可。  
**追问：** defer 里再 panic？  
**题源标签：** 国内高频

## GO-D-06 goroutine 泄漏
**题目：** 线上 goroutine 泄漏常见原因？怎么发现？  
**参考答法要点：** 未退出的 for/select、channel 永久阻塞、忘了 context 取消；pprof goroutine；监控数量。  
**追问：** 和内存涨如何区分？  
**挂钩提示：** 事件处置 worker 若卡住会堆积  
**题源标签：** 国内高频

## GO-D-07 channel
**题目：** 有缓冲 vs 无缓冲？什么场景你不用 channel？  
**参考答法要点：** 无缓冲同步会合；有缓冲解耦；关闭与 range；选 Mutex 共享状态有时更简单。  
**追问：** 往已关闭 channel 写？  
**题源标签：** 国内高频

## GO-D-08 context
**题目：** context 解决什么？传值该不该用？  
**参考答法要点：** 取消/超时/截止向下传递；WithCancel/Timeout/Deadline；值仅请求域元数据；别当全局配置。  
**追问：** 如何贯穿 HTTP/K8s client 调用？  
**题源标签：** 国内高频

## GO-D-09 K8s 事件自动处置
**题目：** 若用 Go 消费 K8s Warning 事件做自动重启/扩容类动作，如何避免事件风暴打崩集群？  
**参考答法要点：** 限流/冷却/去重/只处理可行动 Reason；幂等；熔断人工确认；与 controller 调谐区分。  
**追问：** List-Watch 断线重连？  
**挂钩提示：** S3 事件驱动经历  
**题源标签：** 结合学员经历

## GO-D-10 编码：超时取消的并发计数
**题目：** N 个 goroutine 并发 +1 共享计数；总时长超过 T 后取消未完成工作并输出计数。口述思路，能写 Go 更好。  
**参考答法要点：** context.WithTimeout；WaitGroup；Mutex 或 atomic；select ctx.Done；退出避免泄漏。  
**验收：** 点到取消与同步；不要求完美代码。  
**题源标签：** 国内高频
```


- [ ] **Step 2: Write `CHECKLIST.md`** — GO-D-01…10 会/半会/不会表 + 统计行

- [ ] **Step 3: Write `RESULT.md` 模板**

含：自评统计、建议先学小节（basics / concurrency / 两者）、应入库错题 id 列表、G1/G2 初评、下一步口令建议

- [ ] **Step 4: Verify**

Run: `grep -c '^## GO-D-' 06-golang/00-diagnostic/QUESTIONS.md`  
Expected: `10`

- [ ] **Step 5: Commit**

```bash
git add 06-golang/00-diagnostic/
git commit -m "Add Go diagnostic question pack and result template."
```

---

### Task 5: Go coding line starter G-01

**Files:**
- Create: `06-golang/05-coding/README.md`
- Create: `06-golang/05-coding/G-01-timeout-counter.md`

**Interfaces:**
- Consumes: GO-D-10 同类题可复用；X1 维度
- Produces: drill `G-01`；README 记录表；进三面前 ≥3 次以 Go 为主

- [ ] **Step 1: Write coding README**（范围、记录表、与 Shell C-01 关系：Go 为主计数）

- [ ] **Step 2: Write G-01** — 与 GO-D-10 对齐的可单独练习版（题目、验收、参考思路：context + WaitGroup + Mutex/atomic）

- [ ] **Step 3: Verify files exist**

- [ ] **Step 4: Commit**

```bash
git add 06-golang/05-coding/
git commit -m "Add Go coding-line starter G-01."
```

---

### Task 6: Extend structure checker + handoff

**Files:**
- Modify: `scripts/check-structure.sh`
- Create: `docs/superpowers/plans/HANDOFF-GO-DIAGNOSTIC.md`
- Modify: `README.md`（若需把 Go 摸底标为「题包已就绪」）

**Interfaces:**
- Consumes: all new required paths from Tasks 1–5
- Produces: checker exit 0; handoff steps for `开始 Go 摸底`

- [ ] **Step 1: Add `require` lines** for:

```
00-profile/ANSWERING.md
00-profile/ASSESSMENT.md
review/wrong-book.md
review/job-market/README.md
06-golang/00-diagnostic/QUESTIONS.md
06-golang/00-diagnostic/CHECKLIST.md
06-golang/00-diagnostic/RESULT.md
06-golang/01-basics/README.md
06-golang/02-concurrency/README.md
06-golang/03-cloudnative/README.md
06-golang/04-backend-lite/README.md
06-golang/05-coding/README.md
06-golang/05-coding/G-01-timeout-counter.md
06-golang/mocks/TEMPLATE.md
```

保留既有 require。

- [ ] **Step 2: Run** `bash scripts/check-structure.sh`  
Expected: `Structure check PASSED`

- [ ] **Step 3: Write HANDOFF**

```markdown
# 开练：Go 摸底

1. 读 `00-profile/ANSWERING.md`
2. 开卷 `06-golang/00-diagnostic/QUESTIONS.md`，在 CHECKLIST 自评
3. 对话发送：`开始 Go 摸底`（闭卷模拟或逐题对练）
4. 填 `RESULT.md`；不会/半会写入 `review/wrong-book.md`
5. 更新 `00-profile/ASSESSMENT.md` 的 G1/G2 初评
6. 可并行：`开始一面题库`（容器）或 `扫岗位`
7. E1–E5 进阶仍锁定，勿展开
```

- [ ] **Step 4: Set README Go 摸底状态为** `题包已就绪，待开练`

- [ ] **Step 5: Commit**

```bash
git add scripts/check-structure.sh docs/superpowers/plans/HANDOFF-GO-DIAGNOSTIC.md README.md
git commit -m "Extend structure check and add Go diagnostic handoff."
```

---

### Task 7: Mark specs implemented-ready + self-check

**Files:**
- Modify: three `2026-07-22-*-design.md` status lines to `已确认；实现见 plans/2026-07-22-golang-dual-track-review-infra.md`

- [ ] **Step 1: Update status lines** in the three confirmed specs

- [ ] **Step 2: Run structure check again — PASSED**

- [ ] **Step 3: Commit**

```bash
git add docs/superpowers/specs/
git commit -m "Mark July 22 specs as confirmed and plan-linked."
```

---

## Spec coverage (plan self-review)

| Spec 要求 | Task |
|-----------|------|
| 06-golang 骨架 + 摸底 | 3, 4 |
| Go 编码线 | 5 |
| 错题本 | 2 |
| 岗位雷达目录与说明 | 2 |
| 评估表 + 进阶锁定 | 1 |
| 作答写法 | 1 |
| README 口令/进度 | 1, 6 |
| 国内题感摸底题 | 4 |
| E1–E5 不建题包 | 全局（仅 ASSESSMENT 锁定说明） |
| 结构检查 | 6 |
| 合面配比全量题 | 首期不做（摸底后） |
| 首次真实扫岗位 | 交接后会话执行，非本计划必交付文件 |

Out of plan: full 01-basics/02-concurrency banks, first job-market scan content, 合面题单正式版, E1–E5 materials.
