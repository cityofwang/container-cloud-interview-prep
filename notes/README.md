# 学习笔记

按知识点分类的详解；服务 L3，不替代错题复现得分。  
横切要求见 `00-profile/MINDSETS.md`（对比/选型贯穿）。

## 怎么用

- **不会 / 半会** → 先读对应笔记，再闭卷口述；口述 ≥4 连续 2 次才做出库
- 口令：`补笔记 <主题>`；或训练中教练直接落篇
- 平日仍以**当前专注区（FZ）**错题/复述为主；写笔记服务同域，不跨域开新大课
- 热点与专场排序见 `00-profile/KNOWLEDGE-MAP.md`

## 目录

- `A-target/` — 目标岗主图谱（含 Service/Ingress、排障三路径、Go 陷阱等）
- `B-thin/` — 网络 / OS / 算法等薄册（按需增量）

### A-target 索引（部分）

| 笔记 | 关联题 / 域 |
|------|-------------|
| `k8s-service-ingress.md` | R1-Q04/Q11 · FZ1 |
| `k8s-configmap-secret.md` | R1-Q05 · FZ1 |
| `k8s-probes.md` | R1-Q07 · FZ1 |
| `k8s-list-watch-informer.md` | R1-Q13 · FZ1 |
| `k8s-control-plane-boundary.md` | R1-Q16 · FZ1 |
| `k8s-taint-affinity.md` | R1-Q14 · FZ1 |
| `k8s-kube-proxy-iptables-ipvs.md` | R1-Q18 · FZ1 |
| `k8s-container-snat-dnat.md` | R1-Q20 · FZ1 · 运维开发同构 |
| `docker-bridge-packet-path.md` | R1-Q20 深挖 · 默认 bridge 逐跳 |
| `k8s-cri-containerd-runc-kata.md` | R1-Q21 · FZ1 · JD 高频 |
| `container-image-layers-rootfs.md` | 镜像分层/rootfs · 挂 Q21 |
| `containerd-what-it-does.md` | containerd 职责 · 挂 Q21 |
| `image-registry-manifest-digest.md` | 镜像仓 manifest/digest · 够用级 |
| `k8s-device-plugin-gpu.md` | R1-Q22 · FZ1 · GPU 现象 |
| `k8s-scheduler-filter-score-preempt.md` | R1-Q23 · 调度框架 · 脉脉08-05 |
| `etcd-enough-for-interview.md` | etcd 够用级 · 调度研发 JD |
| `cloud-native-sched-ecosystem.md` | Koordinator/Volcano/Kruise 定位 |
| `k8s-preempt-evict-qos.md` | R1-Q24 · 易混三件套 |
| `k8s-requests-scheduling-oversell.md` | R1-Q25 · requests/超卖 |
| `k8s-troubleshoot-crashloop-oom-notready.md` | R1-Q09/Q19 · FZ1/FZ2 |
| `go-error-wrapping.md` 等 | Go · FZ3/FZ4 |

## 单篇结构

1. 结论背板  
2. 机制要点  
3. **对比**（易混点 / 场景取舍 / 选型；至少一组）  
4. 例题或代码 / 生产现象  
5. 追问边界  
6. 关联错题 / 维  
7. 自测（含一问对比）
