# 一面自标清单

标注：会 / 半会 / 不会。目标：会+半会 ≥ 80% 再预约模拟。

| 题号 | 主题 | 自评 | 补稿链接/笔记 |
|------|------|------|----------------|
| R1-Q01 | Docker/隔离 | 半会 |  |
| R1-Q02 | Pod | 会 |  |
| R1-Q03 | 工作负载 | 半会 |  |
| R1-Q04 | Service/Ingress | 半会 | 2026-07-29 对练：类型/分工有，包路径/代理模型需钉；笔记已有 |
| R1-Q05 | 配置与 Secret | 半会 | [笔记](../notes/A-target/k8s-configmap-secret.md) · 2026-07-29 口述主线对；忌说「密文」 |
| R1-Q06 | 资源与 QoS | 半会 | 2026-07-31 短模硬伤→同日回炉定义过；待再复现巩固 |
| R1-Q07 | 探针 | 半会 | [笔记](../notes/A-target/k8s-probes.md) · 2026-07-29 口述失败后果对 |
| R1-Q08 | 发布回滚 | 会 |  |
| R1-Q09 | 常见排障 | 会 |  |
| R1-Q10 | 监控与事件 | 会 |  |
| R1-Q11 | Service 不通排查 | 半会 | 2026-07-29：selector/后端有；须钉 EP 优先、port≠targetPort；kube-proxy 非 EP 空首因 |
| R1-Q12 | 滚动 Ready 与灰度选型 | 会 |  |
| R1-Q13 | List-Watch 直觉 | 半会 | [笔记](../notes/A-target/k8s-list-watch-informer.md) · 2026-07-29 口述主线对 |
| R1-Q14 | 污点/亲和 | 半会 | [笔记](../notes/A-target/k8s-taint-affinity.md) · 2026-07-30 口述主线过；T2 request对比需钉 |
| R1-Q15 | CNI 现象级 | 会 |  |
| R1-Q16 | 控制面边界 | 半会 | [笔记](../notes/A-target/k8s-control-plane-boundary.md) · 2026-07-29 口述主线对；可补边界一句 |
| R1-Q17 | Pod 创建端到端 | 半会 |  |
| R1-Q18 | iptables vs ipvs | 半会 | [笔记](../notes/A-target/k8s-kube-proxy-iptables-ipvs.md) · 2026-07-30 四句过关；钉「两者都是内核数据面」 |
| R1-Q19 | CrashLoop/OOM/NotReady 三路径 | 半会偏上 | [笔记](../notes/A-target/k8s-troubleshoot-crashloop-oom-notready.md) · 2026-07-31：OOM好；须分清探针→NotReady vs liveness→CrashLoop |
| R1-Q20 | 出网 SNAT / Service DNAT | 半会 | [笔记](../notes/A-target/k8s-container-snat-dnat.md) · 运维开发同构·多厂；网络特训中 |
| R1-Q21 | CRI / containerd / runc / Kata | 未测 | [笔记](../notes/A-target/k8s-cri-containerd-runc-kata.md) · JD 清单 08-04 |
| R1-Q22 | Device Plugin / GPU 调度 | 未测 | [笔记](../notes/A-target/k8s-device-plugin-gpu.md) · JD 清单 08-04 |
| R1-Q23 | Scheduler Filter/Score/抢占 | 未测 | [笔记](../notes/A-target/k8s-scheduler-filter-score-preempt.md) · 脉脉 08-05 |
| R1-Q24 | 抢占 vs 驱逐 vs QoS | 未测 | [笔记](../notes/A-target/k8s-preempt-evict-qos.md) · 题源 08-05 |
| R1-Q25 | requests 与调度/超卖 | 未测 | [笔记](../notes/A-target/k8s-requests-scheduling-oversell.md) · 题源 08-05 |

## 统计

| 档位 | 数量 |
|------|------|
| 会 | 7 |
| 半会 | 13（含 Q20 特训中） |
| 不会 | 0 |
| 未测 | 5（Q21 讲练中、Q22–Q25） |

会+半会 ≈ 开卷主体已摸完；**调度易混 + 运行时**为近期补缺。短模默认**多厂均衡**。

自评日期：2026-07-25；题包增补：… / **2026-08-05 Q23–Q25（题源扫描）**；对练更新：至 08-05
