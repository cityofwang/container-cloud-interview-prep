# 知识图谱（L3）

索引约定见 `docs/superpowers/specs/2026-07-23-l3-roadmap-and-notes-design.md`。  
专注区 / 热点约定见 `docs/superpowers/specs/2026-07-27-focus-zone-and-hotspots-design.md`。  
状态：`未测` / `会` / `半会` / `不会` — 以摸底、清单、模拟分为准。

**热点**（面经驱动，`扫题源` 校准）：`必会` / `高频` / `常考` / `加分` / `冷门`  
**L3 列**：`核心` / `重要` / `可后置`  
同域专场排序：必会/高频 ∩ 核心 → 常考 → 加分。

口令：训练中暴露不会 → 写 `notes/` 或 **P 轨** `07-projects/`；复盘看本表；`看专注区` 看当前 FZ。

**P 轨挂钩列：** `P:<slug>/<章节或 K#>` — 见 [`07-projects/`](../07-projects/README.md)

热点版本：2026-07-27（种子：2026-07-24 + 2026-07-27 题源扫描）

## A 主图谱（目标岗）

| 域 | 维 | 知识点 | 热点 | 场景 | L3 | 状态 | 笔记 / 错题 / P 轨 |
|----|----|--------|------|------|-----|------|---------------------|
| 容器/K8s 基础 | C1 | Service/Ingress（含 NodePort vs LB vs Ingress） | 必会 | 一面对象 | 核心 | 半会 | R1-Q04；[笔记](../notes/A-target/k8s-service-ingress.md) |
| 容器/K8s 基础 | C1 | Service 不通排查（EP/selector/targetPort） | 必会 | 排障路径 | 核心 | 半会 | R1-Q11 |
| 容器/K8s 基础 | C1 | Pod / 工作负载选型 | 必会 | 一面对象 | 核心 | 会/半会 | R1-Q02/Q03 |
| 容器/K8s 基础 | C1 | 探针（liveness/readiness/startup） | 高频 | 一面对象 | 核心 | 半会 | R1-Q07；[笔记](../notes/A-target/k8s-probes.md) |
| 容器/K8s 基础 | C1 | ConfigMap/Secret | 高频 | 一面对象 | 核心 | 半会 | R1-Q05；[笔记](../notes/A-target/k8s-configmap-secret.md) |
| 容器/K8s 基础 | C1 | 资源与 QoS / requests·limits | 高频 | 一面对象 | 核心 | 半会 | R1-Q06；短模硬伤 BestEffort |
| 容器/K8s 基础 | C1 | 发布回滚 / Ready 与灰度选型 | 高频 | 发布灰度 | 核心 | 会 | R1-Q08/Q12 |
| 容器/K8s 基础 | C1 | Pod 创建端到端 | 必会 | 一面对象·合面综合 | 核心 | 半会 | R1-Q17；`PROCESS-FLOWS.md` |
| 容器/K8s 基础 | C1 | List-Watch / Informer 直觉 | 高频 | 云原生Go | 重要 | 半会 | R1-Q13；[笔记](../notes/A-target/k8s-list-watch-informer.md) |
| 容器/K8s 基础 | C1 | 污点/亲和 / 调度过滤打分 | 常考 | 调度混部 | 重要 | 半会 | R1-Q14；[笔记](../notes/A-target/k8s-taint-affinity.md) |
| 容器/K8s 基础 | C1 | CNI 现象级 | 常考 | 排障路径 | 重要 | 会 | R1-Q15 · P:kata/K10（未写章） |
| 容器/K8s 基础 | C1 | 控制面边界 / 组件职责 | 高频 | 一面对象 | 核心 | 半会 | R1-Q16；[笔记](../notes/A-target/k8s-control-plane-boundary.md) |
| 容器/K8s 基础 | C1 | Docker/namespace·cgroup 隔离 | 高频 | 一面对象 | 核心 | 半会 | R1-Q01 · P:kata/K01 |
| 容器/K8s 基础 | C1 | kube-proxy：iptables vs ipvs | 常考 | 一面对象 | 重要 | 半会 | R1-Q18；[笔记](../notes/A-target/k8s-kube-proxy-iptables-ipvs.md) |
| 排障与可观测 | C2 | CrashLoop/OOM/NotReady 路径 | 必会 | 排障路径 | 核心 | 半会 | R1-Q09/Q19；[笔记](../notes/A-target/k8s-troubleshoot-crashloop-oom-notready.md) |
| 排障与可观测 | C2 | 监控告警 / 事件挂钩生产 | 高频 | 排障路径 | 核心 | 会（经历） | R1-Q10；待深挖口述 · P:kata/03-observability |
| 混部/cgroup/CSI | C3 | 混部干扰与隔离、cgroup | 高频 | 调度混部 | 核心 | 未测（经历强） | 故事卡 · P:kata/K13（未写章） |
| 混部/cgroup/CSI | C3 | CSI / PV·PVC 部署坑 | 常考 | 调度混部 | 重要 | 未测（经历强） | 故事卡 |
| Go 基础 | G1 | slice/append | 高频 | Go八股 | 核心 | 半会 | GO-D-01 |
| Go 基础 | G1 | map 并发 | 必会 | Go八股 | 核心 | 会 | GO-D-02 |
| Go 基础 | G1 | error / `%w` / Is/As | 必会 | Go八股 | 核心 | 不会 | [笔记](../notes/A-target/go-error-wrapping.md) · GO-D-03 |
| Go 基础 | G1 | interface nil | 必会 | Go八股 | 核心 | 半会 | [笔记](../notes/A-target/go-interface-nil.md) · GO-D-04 |
| Go 基础 | G1 | defer | 高频 | Go八股 | 核心 | 半会 | GO-D-05 |
| Go 并发 | G2 | goroutine 泄漏 / pprof | 必会 | Go八股·合面综合 | 核心 | 半会 | [笔记](../notes/A-target/go-goroutine-leak.md) · GO-D-06 |
| Go 并发 | G2 | channel / 关闭 / select | 必会 | Go八股 | 核心 | 不会→半会 | GO-D-07；GO-C-02 |
| Go 并发 | G2 | context 取消与传值 | 必会 | Go八股 | 核心 | 不会→半会 | GO-D-08；GO-C-03 |
| Go 并发 | G2 | GMP 口述 | 必会 | Go八股 | 核心 | 未测 | GO-C-01 |
| Go 并发 | G2 | 超时取消并发计数 | 高频 | 合面综合 | 重要 | 半会 | GO-D-10 |
| 云原生 Go | G3 | 事件自动处置防风暴 | 常考 | 云原生Go | 重要 | 半会 | GO-D-09；[设计笔记](../notes/A-target/k8s-event-auto-remediation-design.md) |
| 场景过线 | X1/综合 | 一亿邮件/限流/护 apiserver | 常考 | 合面综合 | 重要 | 未测 | `05-scenario-line/` SCE-01…04 |
| 编码过线 | X1 | 小练习次数 | 高频 | 合面综合 | 核心 | 未测 | `06-golang/05-coding/` |
| 表达 | X2 | 四段式 / 排障 / STAR | 必会 | 合面综合 | 核心 | 进行中 | `ANSWERING.md` |
| 流程熟练度 | C1 | Pod 创建等关键路径 | 必会 | 一面对象 | 核心 | 未测 | `PROCESS-FLOWS.md`；R1-Q17 |
| （观察） | — | Mesh / 多集群 | 冷门 | 合面综合 | 可后置 | — | 观察维 O4 |
| （观察） | — | etcd Raft / 脑裂深挖 | 加分 | 合面综合 | 可后置 | — | 云厂商/基础架构岗加分；L3 不主攻 |

## B 薄册（够用）

| 册 | 知识点 | 热点 | L3 | 状态 | 笔记 |
|----|--------|------|-----|------|------|
| OS | namespace / cgroup 与容器对应 | 高频 | 重要 | 未测（实践强） | 待写 `notes/B-thin/` |
| 网络 | TCP/DNS + Service/CNI 现象排查 | 高频 | 重要 | 未测（弱项） | 待写 |
| 算法 | 数组/哈希/字符串 + 并发过线题 | 常考 | 可后置 | 未测 | 编码过线优先于题海 |
| 数据库 | 默认不开 | 冷门 | 可后置 | — | 雷达连续高频再议 |

## 观察维（未加权，见 ASSESSMENT）

市场或训练中反复出现、但尚未进八维加权的能力，记在 `ASSESSMENT.md`「观察维」；满样本再议是否升级。

## 场景权重速查（调度用）

| 场景 | 相对权重 |
|------|----------|
| 排障路径 | 5 |
| 一面对象 | 5 |
| Go 并发与排障 | 5 |
| Go 基础陷阱 | 4 |
| 调度混部 / cgroup / CSI | 4 |
| List-Watch / Informer 直觉 | 3 |
| Mesh / 多集群 / 纯算法题海 | 1 |
