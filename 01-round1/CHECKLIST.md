# 一面自标清单

标注：会 / 半会 / 不会。目标：会+半会 ≥ 80% 再预约模拟。

| 题号 | 主题 | 自评 | 补稿链接/笔记 |
|------|------|------|----------------|
| R1-Q01 | Docker/隔离 | 半会 |  |
| R1-Q02 | Pod | 会 |  |
| R1-Q03 | 工作负载 | 半会 |  |
| R1-Q04 | Service/Ingress | 半会 | 2026-07-29 对练：类型/分工有，包路径/代理模型需钉；笔记已有 |
| R1-Q05 | 配置与 Secret | 半会 | [笔记](../notes/A-target/k8s-configmap-secret.md) · 2026-07-29 口述主线对；忌说「密文」 |
| R1-Q06 | 资源与 QoS | 会 |  |
| R1-Q07 | 探针 | 半会 | [笔记](../notes/A-target/k8s-probes.md) · 2026-07-29 口述失败后果对 |
| R1-Q08 | 发布回滚 | 会 |  |
| R1-Q09 | 常见排障 | 会 |  |
| R1-Q10 | 监控与事件 | 会 |  |
| R1-Q11 | Service 不通排查 | 半会 | 2026-07-29：selector/后端有；须钉 EP 优先、port≠targetPort；kube-proxy 非 EP 空首因 |
| R1-Q12 | 滚动 Ready 与灰度选型 | 会 |  |
| R1-Q13 | List-Watch 直觉 | 半会 | [笔记](../notes/A-target/k8s-list-watch-informer.md) · 2026-07-29 口述主线对 |
| R1-Q14 | 污点/亲和 | 不会 | [笔记](../notes/A-target/k8s-taint-affinity.md) · 2026-07-29 详解待口述 |
| R1-Q15 | CNI 现象级 | 会 |  |
| R1-Q16 | 控制面边界 | 半会 | [笔记](../notes/A-target/k8s-control-plane-boundary.md) · 2026-07-29 口述主线对；可补边界一句 |
| R1-Q17 | Pod 创建端到端 | 半会 |  |
| R1-Q18 | iptables vs ipvs | 未测 | 题源 2026-07-27 补题 |
| R1-Q19 | CrashLoop/OOM/NotReady 三路径 | 未测 | [笔记](../notes/A-target/k8s-troubleshoot-crashloop-oom-notready.md) |

## 统计

| 档位 | 数量 |
|------|------|
| 会 | 7 / 19 |
| 半会 | 9 / 19 |
| 不会 | 1 / 19 |
| 未测 | 2 / 19 |

会+半会 = **16/19 ≈ 84%**（已过开卷 80% 线；未测 Q18/Q19 + 巩固半会后再约模拟）

自评日期：2026-07-25；题包增补：2026-07-27；对练更新：2026-07-29（多项→半会；Q16 过）
