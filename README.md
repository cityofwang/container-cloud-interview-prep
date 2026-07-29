# 容器云工程师面试训练

总策略：D（广覆盖）｜优先开练：A（大厂容器云 / 混部）｜方式：面次闯关 + Go 双轨  
时间盒：**平日只错题**｜**周末 3～4h 攻坚**（发 `周末开练`）｜碎片用 `我有空 30分钟`

## 进度板

| 项 | 状态 |
|----|------|
| 当前面次 | 一面（开卷自评中） |
| 一面过关 | 未开始（会+半会 ≈84%，**已过开卷 80%**；巩固后再约模拟） |
| 二面过关 | 锁定 |
| 三面过关 | 锁定 |
| 四面过关 | 锁定 |
| Go 摸底 | **已定稿**（2026-07-24 RESULT） |
| Go 当前小节 | 01-basics（**FZ3 再系统收口**；现主攻 FZ1） |
| **当前专注区** | **FZ1 容器/K8s 基础** |
| 合面模拟次数 | 0 |
| 编码练习次数（Go 为主） | 0 / 进三面前需 ≥3 |
| 错题未巩固 | ~19（Q04/Q11 对练→半会，仍未巩固） |
| 能力档 | 未评 L（G1/G2≈2.5） |
| 建议下周包类型 | FZ1 先答后讲 |
| L3 阶段 | P1 专注区打底 |
| 预计 L3 窗口 | 2026-09-22～2026-11-12 |
| 进阶解锁 | 全部锁定（E1–E5） |
| 最近岗位雷达 | **2026-07-29**（对齐：FZ1 不变；算法过线非题海） |
| 最近题源雷达 | **2026-07-27** |
| 评估标准版本 | 2026-07-22-v1 |

## 怎么用

**口令权威表（必维）：** [`00-profile/COMMANDS.md`](00-profile/COMMANDS.md) — 有新口令必须先改该表。  
**操盘：** 你用人话说时间/状态即可；助手按 `CONTINUITY.md` 操盘（**单场不跨专注区**；域内按热点；**先答题再讲解**，禁止开场灌输）。也可发 `按操盘规则继续` / `知识点专场` / `看专注区`。  
**思维：** 对比/选型贯穿始终 → `00-profile/MINDSETS.md`（开题默认带对比点）。  
摘要：`周末开练` / `我有空 30分钟` / `知识点专场` / `错题回炉` / `扫岗位` / `扫题源` / …（完整见口令表）

- **平日**：当前 FZ 错题/复述（≤30 分钟），不跨域开新课  
- **周末**：同 FZ「学一块 + 练一块」约 3～4h  
- **排期**：见 [`review/roadmap/L3-plan.md`](review/roadmap/L3-plan.md)；热点见 [`00-profile/KNOWLEDGE-MAP.md`](00-profile/KNOWLEDGE-MAP.md)  
- **双雷达**：`扫岗位` = JD；`扫题源` = 牛客/GitHub·笔记/面经（最近 2026-07-27）
- 每面四步：开卷题库 → 闭卷模拟 → 复盘补洞 → 过关检查

作答写法见 `00-profile/ANSWERING.md`；能力雷达见 `00-profile/ASSESSMENT.md`；阶段画像见 `00-profile/STAGE-PORTRAITS.md`；周末包说明见 `review/weekend/README.md`。  
**新对话续聊**：说 `面试训练` / `按操盘规则继续`（项目 Skill：`.cursor/skills/interview-coach`），或复制 `CONTINUITY.md` 开场模板。  
一键拷模板：`bash scripts/resume-training.sh`（可选参数如 `"我有空 30分钟"`）。  
纠偏口令：`请严格按 CONTINUITY.md 与 docs/superpowers/specs/ 下已确认设计执行。`

## 目录

- `CONTINUITY.md` 新对话续聊一页纸（上下文满了用这个）
- `00-profile/` 背景、故事卡、作答、评估、知识图谱、阶段画像、口令表、思维清单、**流程清单**
- `01-round1/` … `04-round4/` 各面题库
- `05-coding-line/` 过线编码（Shell 等）
- `05-scenario-line/` **场景/容量设计过线**（一亿邮件、限流、护 apiserver 等）
- `06-golang/` Go 双轨（摸底/小节/编码）
- `notes/` 按知识点分类的学习笔记（不会详解）
- `review/` 错题本、岗位雷达、**题源雷达**、周末包、`roadmap/`（L3 排期）
- `mocks/` 模拟记录
- `docs/superpowers/` 设计与计划

## 结构自检

```bash
bash scripts/check-structure.sh
```

教练唤醒：`bash scripts/resume-training.sh` · Skill 设计见 `docs/superpowers/specs/2026-07-26-interview-coach-skill-design.md`
