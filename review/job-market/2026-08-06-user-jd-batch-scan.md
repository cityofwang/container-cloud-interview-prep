# 学员投递 JD 批次扫描（2026-08-06）

> **来源：** 学员提供 **6 张猎聘（liepin.com）JD 截图**（2026-08-06）。  
> **渠道：** [猎聘](https://www.liepin.com/) — 学员主动检索，非助手爬取。  
> **口令等价：** `补岗位 JD` / 学员发猎聘截图或文字。  
> **纪律：** 并入热点与 P 轨排期；**不改 FZ 串行**；补题须 `按报告补题` 确认。

## 1. 来源与局限

| 项 | 说明 |
|----|------|
| 获取方式 | **非**助手主动爬取；学员在 **猎聘** 检索 → 截图 → 助手解读 → 落库 |
| 渠道 | **猎聘 liepin.com**（2026-08-06 批次）；不要求账号密码 |
| 局限 | 猎聘帖无公司全名/薪资的已按岗位类型归档；银行/ToB 软技能不自动加权 |
| 为何上次对话「没找到」 | 内容在**对话附件**里，未写入仓库前新 Chat **不可见**；现已落 `review/job-market/` |
| 后续 | 学员继续发 **猎聘** JD → 追加本文件 §7 或新建 `YYYY-MM-DD-liepin-*.md` |

## 2. 命中岗位摘要（6 岗）

| # | 岗位类型 | 核心叙事 | 年限/语言 | 与你画像贴合 |
|---|----------|----------|-----------|--------------|
| 1 | **云原生高级研发** | 容器引擎 + K8s 大规模 + **混部调度** + 弹性 + 二次开发 + 开源 | 本科+；Go/Java/C++ | ⭐⭐⭐⭐⭐ 最贴 |
| 2 | **容器云运维和开发** | 总行容器云平台建设；K8s/Docker；Calico/Flannel；Go/Operator | 3 年及以下；本科+ | ⭐⭐⭐ 偏交付 |
| 3 | **容器云运维工程师** | Linux 性能；Docker/Mesos/K8s；CI/CD；Prometheus；Calico | 未详；Shell/Python/Go | ⭐⭐ SRE 向 |
| 4 | **云原生容器网络** | CNI **控制面/数据面**；Underlay/Overlay；eBPF/DPDK；网络编程 | 2 年+；Go/C | ⭐⭐⭐ 专网岗 |
| 5 | **K8S 开发工程师-DevOps**（MiniMax 类） | K8s 平台；CI/CD；Helm/Operator；**containerd/CRI-O**；可观测；AI 应用 | 未详；Go | ⭐⭐⭐⭐ |
| 6 | **阿里云 容器&K8s 高级研发** | ACS；**Serverless**；CRD/Controller；containerd/CNI/CSI；AI 训推 | 5 年+；Go | ⭐⭐⭐⭐⭐ |

**主投建议（本轮）：** #1 / #5 / #6 研发平台向；#4 仅在有网络专岗意愿时；#2/#3 运维叙事不同维。

## 3. 高频能力词（6 岗并集）

| 权重 | JD 常见说法 | 要能讲什么 | 本仓状态 | 动作 |
|------|-------------|------------|----------|------|
| 极高 | Go | 平台/Operator/runtime | FZ3 排期 | 保持 |
| 极高 | K8s 调度/网络/存储/RBAC | 组件 + 现象排障 | FZ1 进行中 | 继续 |
| 极高 | **containerd / CRI / shim / 二次开发** | kubelet→shim→runtime；能读改源码 | Q21 未测；**P 轨 kata R01–R04** | **FZ1 + P 轨加力** |
| 极高 | Operator / CRD / Controller | Informer + 调谐 | Q13 半会 | 补 demo 或设计稿 |
| 高 | **CNI**（Calico/Flannel/插件架构） | 现象 + Host/Guest 边界 | Q15 会；Kata R06 未开始 | **CNI 章 + R06** |
| 高 | **可观测 / Prometheus** | 指标从哪来、分层大盘 | Q10 会；P kata 03 | **升 S6 故事卡** |
| 高 | 混部 / QoS / cgroup / 资源调度 | 双层 cgroup、PodOverhead | 经历强/FZ5 | 合面加压 |
| 高 | CSI / 存储插件 | PV/PVC + Kata 根盘 | 故事未测 | FZ5 / 04-storage 薄章 |
| 中↑ | **Kata / RuntimeClass / 安全运行时** | runc vs VM 隔离；生产边界 | P 轨 MVP+ | **08 必考清单 + R 轨** |
| 中↑ | CI/CD（Jenkins/GitLab/ArgoCD/Harbor） | 流水线一句能画 | 缺口 | 观察维 O8 |
| 中 | Linux 性能（CPU/网/存） | 分层排障 | B 薄册 | 按需 |
| 中 | Serverless / 弹性 / 密度 | VM 开销 vs 隔离 | 缺口 | 观察维 O9 |
| 中（专岗） | eBPF / DPDK / VxLAN / SmartNIC | CNI 数据面 | 弱 | **仅投 #4 时开 N 轨** |
| 低～中 | Ansible / ELK / 银行数据中心 | 运维交付 | — | 不主攻 |

## 4. 岗位类型 → 训练映射

### A. 高级研发（#1 / #6）— 主叙事

| 卖点 | 训练落点 |
|------|----------|
| 容器引擎二次开发 | `项目专场 kata 读代码 R01–R05` |
| 大规模稳定性 | FZ2 排障 + S6 节点 Agent |
| Serverless/弹性（#6） | 08-checklist P2 + RuntimeClass 密度 tradeoff |
| CRD/Controller（#6） | Q13 + event remediation 设计 |

### B. K8s DevOps 平台（#5）

| 卖点 | 训练落点 |
|------|----------|
| containerd/CRI-O | R1-Q21 + R01 |
| Helm/Operator | 小 Operator 或口述 |
| 可观测 | R04/R08 + `03-observability` |
| AI 平台语境 | 一句：Kata 隔离 + GPU/Device Plugin Q22 |

### C. 运维+开发（#2 / #3）

Kata 作 **runtime 加分**；主菜 K8s 运维、Calico、Prometheus、CI/CD。不单独加 FZ。

### D. 容器网络专岗（#4）

| 缺口 | 动作 |
|------|------|
| CNI 控制面/数据面 | `04-network-tcfilter-tap` + Kata R06 |
| eBPF/DPDK | 观察维；投 #4 前单开专题 |

## 5. 题库 / P 轨增补建议（待 `按报告补题` 确认）

| ID | 内容 | 优先级 |
|----|------|--------|
| R1-Q21 | CRI/containerd/Kata（已有） | P0 立即测 |
| P:kata R01–R04 | 读代码轨道 | P0 周末 +1h |
| S6 | 节点 Agent + Kata 可观测 STAR | P0 |
| CNI 深化章 | Calico vs Flannel + Kata TAP | P1 |
| O8 | CI/CD 现象级 | P2 观察 |
| O9 | Serverless/RuntimeClass 密度 | P2 观察 |

## 6. 评估校准建议

**本周无需改八维权重。** 建议：

1. **KNOWLEDGE-MAP**：CRI/Kata 维持 **高频·核心**；CNI 备注升「6 岗 4 提及」  
2. **投递口径**：主投研发 #1/#5/#6；运维岗单独改简历叙事  
3. **P 轨**：kata `SESSION-STATE` 与 JD 技能词对齐（R04 优先）

## 7. 原始 JD 要点（归档）

### JD-1 云原生高级研发

- 职责：容器引擎及生态、K8s 大规模管理、**混部调度**、弹性伸缩、分布式云资源编排、生产问题端到端、开源社区  
- 要求：本科+；数据结构算法；TCP/IP/HTTP；Go/Java/C++；K8s 及容器生态**使用与原理**、**扩展或二次开发**；云产品/容器平台经验优先；架构设计、ToB 沟通  

### JD-2 容器云运维和开发

- 职责：总行容器云平台建设维护、工具开发、应用容器化  
- 要求：计通/自动化本科+；K8s 架构安装配置维护；Docker 镜像；**Calico/Flannel**；分布式存储加分；Linux/TCP/IP；**Go 或 K8s Operator**；银行数据中心加分  

### JD-3 容器云运维工程师

- 职责：大规模集群高性能/可靠性/异常处理；工单与知识库  
- 要求：Linux/Shell/性能分析；Docker/Mesos/K8s；GitLab/Jenkins/Harbor；Nginx/MySQL/ELK 等容器化部署；**Prometheus**；Ansible/Shell/Python/Go；**Calico** overlay  

### JD-4 云原生容器网络

- 职责：容器网络**控制面/数据面**设计开发优化；新技术预研  
- 要求：计科本科+ 2 年+；Go/C；TCP/IP、网络编程与性能；**Underlay/Overlay**；**K8s + CNI** + 至少一种开源 CNI  
- 优先：Linux 内核/DPDK/**eBPF**/CNI；SmartNIC/P4；VxLAN/SRv6；VPC/LB  

### JD-5 K8S 开发工程师-DevOps

- 职责：K8s 平台构建优化；CI/CD；Helm/Operator；微服务编排与**可观测**；AI 应用交付  
- 要求：调度/网络/存储/RBAC；Docker；**containerd/CRI-O**；Jenkins/GitLab CI/ArgoCD/Tekton；Operator/CRD 或 K8s 源码理解  

### JD-6 阿里云 容器&K8s 高级研发

- 职责：ACS 架构迭代；AI 大模型训推/大数据/Agent 的 K8s 基建；**Serverless** 成本与调度；前沿容器技术  
- 要求：5 年+后端、**精通 Go**；K8s 深度 + **CRD/Operator/Controller**；**Docker/containerd**、**CNI/CSI**；IaaS/PaaS 资源计费配额；AI 加分  

## 8. 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-06 | 初版：学员猎聘 6 截图批次；并入 skills-inventory §7 |
