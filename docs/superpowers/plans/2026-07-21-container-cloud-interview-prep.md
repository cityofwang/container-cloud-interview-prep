# Container Cloud Interview Prep Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first usable training kit: profile, README progress board, story-card templates, Round-1 question pack (~10), mock log template, and coding-line starter — so the learner can start open-book study and the first mock interview.

**Architecture:** Markdown-only training repo. Each round owns its question bank and answer notes; `mocks/` stores scored sessions; `05-coding-line/` holds over-the-line script/algorithm drills. Content is added round-by-round (no full dump). Round 2–4 full banks are out of this plan’s deliverable scope; only placeholders + README pointers are created.

**Tech Stack:** Markdown, git, shell checks for structure validation (no app runtime).

## Global Constraints

- Train mode: 面次闯关 (题库小节 → 闭卷模拟 → 复盘 → 过关)
- Strategy: 总策略 D（广覆盖）+ 优先 A（大厂容器云 / 混部调度）
- Never invent project experience the learner did not do; hook prompts to: 事件逻辑、cgroup、在离线混部、CSI、监控告警、日常排障
- Coding line: Shell/Python + 极简算法 only; not LeetCode-heavy
- Round-1 first batch: about 10 questions with 参考答法要点 + 追问 + 挂钩提示
- Do not commit unless the user asks (except when a plan step explicitly says commit and the user already chose plan execution that includes commits — prefer ask if unclear)
- Spec source of truth: `docs/superpowers/specs/2026-07-21-container-cloud-interview-prep-design.md`

---

## File Structure

| Path | Responsibility |
|------|----------------|
| `README.md` | How to use + progress board (current round, pass status) |
| `00-profile/PROFILE.md` | Learner background, goals, strengths/gaps |
| `00-profile/STORY-CARDS.md` | Draft STAR frames for 混部/cgroup/事件/CSI/监控 |
| `01-round1/QUESTIONS.md` | Round-1 question pack (~10) with answers & follow-ups |
| `01-round1/CHECKLIST.md` | 会/半会/不会 self-mark sheet |
| `02-round2/README.md` | Placeholder: unlock after Round-1 pass |
| `03-round3/README.md` | Placeholder: unlock after Round-2 pass |
| `04-round4/README.md` | Placeholder: unlock after Round-3 pass |
| `05-coding-line/README.md` | Coding-line rules + index |
| `05-coding-line/01-shell-pod-events.md` | First Shell drill |
| `mocks/TEMPLATE.md` | Mock session score template |
| `scripts/check-structure.sh` | Validates required files exist |

---

### Task 1: README progress board + structure checker

**Files:**
- Create: `README.md`
- Create: `scripts/check-structure.sh`
- Test: run `bash scripts/check-structure.sh` (expect fail until later tasks add files — after Task 1 alone, script should list missing files and exit non-zero)

**Interfaces:**
- Consumes: none
- Produces: progress board fields (`当前面次`, `过关状态`, `编码练习次数`); checker exits 0 only when all required paths from File Structure exist

- [ ] **Step 1: Write `README.md`**

```markdown
# 容器云工程师面试训练

总策略：D（广覆盖）｜优先开练：A（大厂容器云 / 混部）｜方式：面次闯关

## 进度板

| 项 | 状态 |
|----|------|
| 当前面次 | 一面（准备中） |
| 一面过关 | 未开始 |
| 二面过关 | 锁定 |
| 三面过关 | 锁定 |
| 四面过关 | 锁定 |
| 编码练习次数 | 0 / 进三面前需 ≥3 |

## 怎么用

对话口令：`开始一面题库` / `开始模拟` / `复盘` / `补洞` / `编码练一题` / `过关检查`

每面四步：开卷题库 → 闭卷模拟 → 复盘补洞 → 过关检查

## 目录

- `00-profile/` 背景与故事卡
- `01-round1/` … `04-round4/` 各面题库
- `05-coding-line/` 过线编码
- `mocks/` 模拟记录
- `docs/superpowers/` 设计与计划

## 结构自检

```bash
bash scripts/check-structure.sh
```
```

- [ ] **Step 2: Write `scripts/check-structure.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
missing=0
require() {
  if [[ ! -e "$root/$1" ]]; then
    echo "MISSING: $1"
    missing=1
  else
    echo "OK: $1"
  fi
}
require "README.md"
require "00-profile/PROFILE.md"
require "00-profile/STORY-CARDS.md"
require "01-round1/QUESTIONS.md"
require "01-round1/CHECKLIST.md"
require "02-round2/README.md"
require "03-round3/README.md"
require "04-round4/README.md"
require "05-coding-line/README.md"
require "05-coding-line/01-shell-pod-events.md"
require "mocks/TEMPLATE.md"
if [[ "$missing" -ne 0 ]]; then
  echo "Structure check FAILED"
  exit 1
fi
echo "Structure check PASSED"
```

- [ ] **Step 3: Make executable and run (expect FAIL)**

Run:

```bash
chmod +x scripts/check-structure.sh
bash scripts/check-structure.sh
```

Expected: prints multiple `MISSING: ...` and exits 1

- [ ] **Step 4: Commit** (only if user asked to commit during execution)

```bash
git add README.md scripts/check-structure.sh
git commit -m "Add training README and structure checker."
```

---

### Task 2: Profile + story card drafts

**Files:**
- Create: `00-profile/PROFILE.md`
- Create: `00-profile/STORY-CARDS.md`

**Interfaces:**
- Consumes: learner facts from design spec §1
- Produces: five story-card IDs `S1`–`S5` referenced by Round-1 挂钩提示

- [ ] **Step 1: Write `00-profile/PROFILE.md`**

```markdown
# 学员画像

## 基本信息

- 工作年限：约 6 年
- 自我评估深度：偏初中级运维内容（B），按中高级面准备并补齐缺口
- 技术栈：Docker + 托管 K8s（ACK/EKS 类）
- 编码：几乎不刷题；会改脚本、看日志 → 编码线按「过线」

## 目标

- 总策略：D 广覆盖
- 优先：A 大厂容器云 / 基础架构 / 混部调度
- 训练：面次闯关 + 题库沉淀 + 定期模拟

## 强项（可深挖）

- 基于 K8s 事件做运维逻辑
- cgroup / 资源隔离相关实践
- 在离线混部
- 参与 CSI 部署流程
- 监控告警与日常排障

## 弱项（需补）

- 控制面深挖（apiserver/etcd/scheduler 交互）
- 网络模型（CNI 原理层）
- 自建集群 / 升级 / HA 表述
- 算法/编码面试过线能力
- 资深面试官追问下的结构化表达

## 表达注意

- 不贬低 6 年经历；强调「托管集群上的生产问题与资源/混部深度」
- 不知道的边界要诚实，并给出学习/排查路径
```

- [ ] **Step 2: Write `00-profile/STORY-CARDS.md`**

每个故事卡必须含：情境 / 目标 / 动作 / 结果 / 反思 / 可能追问。先留「待学员补全」占位句，不编造数据。

```markdown
# 项目故事卡（草稿）

> 规则：只写真实做过的事；数字与系统名可脱敏。面试前把「待补全」填实。

## S1 在离线混部

- 情境：待补全（业务在线 + 离线任务共节点的背景）
- 目标：待补全（干扰可控 / 利用率提升等）
- 动作：待补全（cgroup/qos/调度或水位相关你做过的步骤）
- 结果：待补全（可观测指标或事故减少，能量化最好）
- 反思：待补全（边界、踩坑、若重来怎么做）
- 可能追问：如何量化干扰？隔离失效时怎么发现？和 requests/limits 的关系？

## S2 cgroup / 资源隔离

- 情境：待补全
- 目标：待补全
- 动作：待补全（cpu/memory/io 哪一类、看过哪些文件或指标）
- 结果：待补全
- 反思：待补全
- 可能追问：cgroup v1 vs v2？OOM 时杀谁？与 K8s QoS 的映射？

## S3 K8s 事件驱动运维逻辑

- 情境：待补全（订阅/监听哪些事件）
- 目标：待补全（自动处置还是告警 enrichment）
- 动作：待补全
- 结果：待补全
- 反思：待补全
- 可能追问：事件风暴怎么降噪？失败重试？与 controller 的区别？

## S4 CSI 部署参与

- 情境：待补全
- 目标：待补全
- 动作：待补全（部署步骤、权限、StorageClass、排过错）
- 结果：待补全
- 反思：待补全
- 可能追问：PV/PVC 绑定失败怎么查？挂载超时？节点拓扑？

## S5 监控告警与排障

- 情境：待补全（一次真实告警或排障）
- 目标：待补全
- 动作：待补全（指标 → 事件 → 日志 → 结论）
- 结果：待补全
- 反思：待补全
- 可能追问：如何减少误报？SLO 怎么定？值班升级路径？
```

- [ ] **Step 3: Verify files exist**

Run: `test -f 00-profile/PROFILE.md && test -f 00-profile/STORY-CARDS.md && echo OK`  
Expected: `OK`

- [ ] **Step 4: Commit** (only if user asked)

```bash
git add 00-profile/PROFILE.md 00-profile/STORY-CARDS.md
git commit -m "Add learner profile and story card drafts."
```

---

### Task 3: Round-1 question pack + checklist

**Files:**
- Create: `01-round1/QUESTIONS.md`
- Create: `01-round1/CHECKLIST.md`

**Interfaces:**
- Consumes: story IDs `S1`–`S5` from Task 2
- Produces: exactly 10 questions `R1-Q01` … `R1-Q10` for open-book + mock

- [ ] **Step 1: Write `01-round1/QUESTIONS.md` with all 10 questions below (verbatim)**

```markdown
# 一面题包（第一批）

开卷先自评，再闭卷模拟。每题按：结论 → 原理要点 → 你怎么做/怎么查。

## R1-Q01 Docker 与 VM；namespace / cgroup

**题目：** 容器和虚拟机核心差别是什么？Linux namespace 与 cgroup 分别解决什么问题？

**参考答法要点：**
- VM：硬件级虚拟化，独立 Guest OS；隔离强、启动重、密度低
- 容器：共享宿主机内核；用 namespace 做隔离视图，用 cgroup 做资源限制
- namespace 常见：pid/net/mnt/uts/ipc/user ——「看见什么」
- cgroup：cpu/memory/io/pids 等 ——「能用多少」
- 一句话：隔离看 namespace，配额/保障看 cgroup

**追问：** 为什么容器逃逸危险？混部场景为何更依赖 cgroup？

**挂钩提示：** S2（cgroup）；可带一句混部为何要限制干扰（S1）

## R1-Q02 Pod 是什么

**题目：** 为什么 K8s 调度与管理的最小单位是 Pod 而不是容器？同 Pod 内容器共享什么？

**参考答法要点：**
- Pod = 共享网络与存储命名空间的一组容器（通常强耦合）
- 同 Pod：同一 IP/端口空间、可 localhost 通信、可共享 volume
- pause/infra 容器持有网络命名空间（实现细节可提一层）
- 边车模式：代理、日志、加固与主容器同生命周期

**追问：** 什么时候不该把两个进程塞进同一 Pod？

**挂钩提示：** 排障时先确认问题在容器内还是 Pod/节点层（S5）

## R1-Q03 工作负载控制器

**题目：** Deployment / StatefulSet / DaemonSet 怎么选？

**参考答法要点：**
- Deployment：无状态、可互换副本、滚动更新；Web/API
- StatefulSet：稳定身份、有序扩缩、每实例存储；ZK/Etcd/部分中间件
- DaemonSet：每节点（或选中节点）一个；日志 agent、node exporter、部分网络/存储插件
- Job/CronJob：跑完就走 / 定时（一面能点到即可）

**追问：** CSI node plugin 为何常见 DaemonSet？

**挂钩提示：** S4（CSI 部署形态）

## R1-Q04 Service 与 Ingress

**题目：** ClusterIP / NodePort / LoadBalancer 差异？和 Ingress 如何分工？

**参考答法要点：**
- Service：稳定虚拟 IP + kube-proxy/IPVS 转发到 Endpoints/EndpointSlice
- ClusterIP：集群内；NodePort：节点端口；LB：云厂商负载均衡挂到节点/Pod
- Ingress：HTTP(S) L7 路由（主机/路径/TLS），背后仍落到 Service
- 选型：东西向 ClusterIP；暴露 HTTP 常用 Ingress；非 HTTP 或简单暴露用 LB/NodePort

**追问：** Service 选不到 Pod 时怎么查（label/selector/endpoints）？

**挂钩提示：** S5 网络类排障入口

## R1-Q05 ConfigMap 与 Secret

**题目：** ConfigMap 和 Secret 区别？Secret 安全上要注意什么？

**参考答法要点：**
- 都是配置投递（env/volume）；Secret 面向敏感数据、会 base64（不是加密）
- etcd 中可能近明文；需加密 at rest、RBAC 收紧、少挂载、轮转
- 实践：外置 KMS/密封密钥/禁止打进镜像；权限最小化

**追问：** 误把 Secret 打进镜像或日志怎么发现与补救？

**挂钩提示：** 无强故事则讲规范；有相关经历再挂钩

## R1-Q06 requests/limits 与 QoS

**题目：** requests 与 limits 含义？三种 QoS？对调度和驱逐的影响？

**参考答法要点：**
- requests：调度与资源预留依据；limits：上限
- Guaranteed：request=limit 且都设置；Burstable：未齐或不等；BestEffort：都未设
- 压力下 BestEffort 更先被挤；CPU throttle vs Memory OOM 行为不同
- 混部/干扰治理常从合理 request + limit + 观测开始

**追问：** 只设 limit 不设 request 会怎样？

**挂钩提示：** S2、S1

## R1-Q07 探针

**题目：** liveness / readiness / startup 区别与误配后果？

**参考答法要点：**
- liveness 失败 → 重启容器；readiness 失败 → 摘流量；startup 保护慢启动
- liveness 打到依赖不稳的接口 → 重启风暴
- readiness 过松 → 带病接流量；过严 → 容量假死
- 探针超时/周期要匹配真实启动与依赖

**追问：** 和滚动更新失败有何关系？

**挂钩提示：** S5 发布/告警类

## R1-Q08 滚动更新与回滚

**题目：** Deployment 滚动更新怎么保证可用？如何回滚？如何确认健康？

**参考答法要点：**
- maxUnavailable / maxSurge；新 Pod Ready 再缩老 Pod
- `kubectl rollout status/history/undo`；保留 ReplicaSet
- 确认：readiness、错误率、延迟、事件、关键业务指标
- 变更三板斧：可回滚、可观测、小步灰度（一面点到）

**追问：** 镜像有问题但 Pod Running 的情况？

**挂钩提示：** S5

## R1-Q09 常见异常排查

**题目：** Pending / ImagePullBackOff / CrashLoopBackOff 你的排查顺序？

**参考答法要点：**
- Pending：describe 事件 → 资源/亲和/污点/PVC
- ImagePull：镜像名/权限/网络/凭证
- CrashLoop：日志 → 退出码 → 探针误杀 → 配置/依赖/OOM
- 固定路径：事件 → 资源描述 → 日志 → 节点/存储/网络

**追问：** 如何区分应用 bug 与环境问题？

**挂钩提示：** S3（事件）、S5

## R1-Q10 监控告警与事件驱动

**题目：** 口述一条监控告警链路；如何基于 K8s 事件做运维逻辑？

**参考答法要点：**
- 指标（Prometheus 等）+ 日志 + 事件/链路，告警要可行动
- 事件：Warning/Failed* 等触发通知、enrich、自动止血（需防抖）
- 降噪：聚合、抑制、冷却、只对可行动事件自动化
- 与「控制器调谐」区别：你做的是运维侧反应，不是替换控制面

**追问：** 事件风暴时怎么保证自动化不伤集群？

**挂钩提示：** S3、S5（主故事题）
```

- [ ] **Step 2: Write `01-round1/CHECKLIST.md`**

```markdown
# 一面自标清单

标注：会 / 半会 / 不会。目标：会+半会 ≥ 80% 再预约模拟。

| 题号 | 主题 | 自评 | 补稿链接/笔记 |
|------|------|------|----------------|
| R1-Q01 | Docker/隔离 |  |  |
| R1-Q02 | Pod |  |  |
| R1-Q03 | 工作负载 |  |  |
| R1-Q04 | Service/Ingress |  |  |
| R1-Q05 | 配置与 Secret |  |  |
| R1-Q06 | 资源与 QoS |  |  |
| R1-Q07 | 探针 |  |  |
| R1-Q08 | 发布回滚 |  |  |
| R1-Q09 | 常见排障 |  |  |
| R1-Q10 | 监控与事件 |  |  |

统计：会__ 半会__ 不会__ ｜ 会+半会比例__%
```

- [ ] **Step 3: Verify question IDs**

Run:

```bash
grep -c '^## R1-Q' 01-round1/QUESTIONS.md
```

Expected: `10`

- [ ] **Step 4: Commit** (only if user asked)

```bash
git add 01-round1/QUESTIONS.md 01-round1/CHECKLIST.md
git commit -m "Add Round-1 question pack and checklist."
```

---

### Task 4: Later-round placeholders + mock template

**Files:**
- Create: `02-round2/README.md`
- Create: `03-round3/README.md`
- Create: `04-round4/README.md`
- Create: `mocks/TEMPLATE.md`

**Interfaces:**
- Consumes: scoring rubric from design §5
- Produces: mock fields used in live sessions (`技术深度`, `表达结构`, `岗位匹配`, per-question 1–5)

- [ ] **Step 1: Write round placeholders**

Create `02-round2/README.md`:

```markdown
# 二面（锁定）

解锁条件：一面过关（见设计过关标准）。

预告范围：排障深挖、cgroup、在离线混部、CSI、Service/CNI 现象级理解。主故事：S1/S2/S4。
```

Create `03-round3/README.md`:

```markdown
# 三面（锁定）

解锁条件：二面过关；且编码练习累计 ≥3 次。

预告范围：混部/资源取舍、告警可行动性、变更回滚与容量、故障复盘（STAR）、轻量系统设计（如 CSI/监控插件灰度）。
```

Create `04-round4/README.md`:

```markdown
# 四面（锁定）

解锁条件：三面过关。

预告范围：项目交叉深挖、协作与值班压力、动机与成长表达、HR 口径（离职原因/期望/稳定性）。
```

- [ ] **Step 2: Write `mocks/TEMPLATE.md`**

```markdown
# 模拟记录｜面次：__｜日期：__

## 总分

| 维度 | 分 (1-5) |
|------|----------|
| 技术深度 |  |
| 表达结构 |  |
| 与岗位匹配 |  |

过关参考：技术深度 ≥ 3.5 且无硬伤。

## 逐题

| 题号 | 分 | 硬伤？ | 备注 |
|------|----|--------|------|
|  |  |  |  |

## 经历故事是否用上

- 用到的故事卡：
- 缺失的量化/细节：

## 下次只补

1.
2.
3.
```

- [ ] **Step 3: Verify**

Run: `test -f mocks/TEMPLATE.md && test -f 02-round2/README.md && echo OK`  
Expected: `OK`

- [ ] **Step 4: Commit** (only if user asked)

```bash
git add 02-round2/README.md 03-round3/README.md 04-round4/README.md mocks/TEMPLATE.md
git commit -m "Add later-round placeholders and mock template."
```

---

### Task 5: Coding-line starter

**Files:**
- Create: `05-coding-line/README.md`
- Create: `05-coding-line/01-shell-pod-events.md`

**Interfaces:**
- Consumes: profile coding level A
- Produces: first drill `C-01`; README explains 进三面前 ≥3 次练习

- [ ] **Step 1: Write `05-coding-line/README.md`**

```markdown
# 过线编码

目标：大厂若有编码轮，不因「完全不会写」挂掉。不做算法岗刷题。

## 范围

- Shell：日志/事件文本处理、排查小脚本
- Python：同样场景的可读版本
- 极简算法：数组 / 哈希 / 字符串（后续练习再加）

## 记录

| 编号 | 日期 | 完成？ | 耗时 | 笔记 |
|------|------|--------|------|------|
| C-01 |  |  |  |  |

进三面前至少完成 3 次（可重复同类题改写）。
```

- [ ] **Step 2: Write `05-coding-line/01-shell-pod-events.md`**

```markdown
# C-01 统计 Pod 事件类型次数（Shell）

## 题目

给定多行文本（模拟 `kubectl get events` 精简输出），每行格式：

```text
TYPE    REASON      OBJECT
Warning Failed      pod/foo
Normal  Scheduled   pod/bar
Warning BackOff     pod/foo
```

用 Shell（bash + 常见命令）统计每种 `REASON` 出现次数，按次数降序输出。

## 验收

- 对示例输入输出含 `Failed`/`Scheduled`/`BackOff` 的计数
- 能口头说明用了哪些命令、为何不用复杂框架

## 参考思路（先自己写再看）

`awk`/`cut` + `sort` + `uniq -c` + `sort -nr`

## 拓展

改成只统计 `Warning` 行；或输出 JSON 行（可用 Python）。
```

- [ ] **Step 3: Run full structure check (expect PASS)**

Run: `bash scripts/check-structure.sh`  
Expected: all `OK:` lines and `Structure check PASSED`

- [ ] **Step 4: Update README 进度板** — set `当前面次` to `一面（题库已就绪，待开卷）`

- [ ] **Step 5: Commit** (only if user asked)

```bash
git add 05-coding-line/README.md 05-coding-line/01-shell-pod-events.md README.md
git commit -m "Add coding-line starter and mark Round-1 ready."
```

---

### Task 6: Spec coverage self-check + handoff note

**Files:**
- Create: `docs/superpowers/plans/HANDOFF-ROUND1.md`

**Interfaces:**
- Consumes: all files from Tasks 1–5
- Produces: short handoff telling the chat agent how to start `开始一面题库`

- [ ] **Step 1: Write handoff**

```markdown
# 首期交付完成 → 开始训练

学员已确认 spec。首期材料就绪后：

1. 请学员打开 `01-round1/QUESTIONS.md` + `CHECKLIST.md` 开卷自评
2. 同步请学员把 `00-profile/STORY-CARDS.md` 里「待补全」尽量填实（尤其 S3/S5）
3. 自评会+半会 ≥80% 后，对话发送：`开始模拟`
4. 模拟使用 `mocks/TEMPLATE.md` 复制为 `mocks/2026-XX-XX-round1.md` 打分
5. 编码可穿插：`编码练一题` → C-01

二面题库不在首期范围；一面过关后再开新计划/任务。
```

- [ ] **Step 2: Confirm structure check still PASS**

Run: `bash scripts/check-structure.sh`  
Expected: PASSED

- [ ] **Step 3: Commit** (only if user asked)

```bash
git add docs/superpowers/plans/HANDOFF-ROUND1.md
git commit -m "Add Round-1 training handoff note."
```

---

## Spec coverage (plan self-review)

| Spec 要求 | Task |
|-----------|------|
| 仓库目录与 README 进度 | Task 1, 5 |
| 00-profile 背景强弱项 | Task 2 |
| 故事卡挂钩真实经历 | Task 2 |
| 一面题包约 10 题 | Task 3 |
| 模拟记录与打分模板 | Task 4 |
| 二三四面不一次堆全量（占位） | Task 4 |
| 过线编码旁线 | Task 5 |
| 启动顺序：骨架→profile→一面→开练 | Tasks 1–6 + HANDOFF |
| 不编造经历 / 不过度算法 | Global Constraints + story 待补全 |

Out of this plan (later plans): full Round-2/3/4 banks, HR 口径定稿, 更多算法题。

Placeholder scan: none intentionally left as TBD in implementation steps; story cards use explicit「待补全」for learner facts only.
