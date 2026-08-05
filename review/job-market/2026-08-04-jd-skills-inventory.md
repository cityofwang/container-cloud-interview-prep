# JD 技能词清单 → 训练缺口（2026-08-04）

> 口令等价：岗位技能填补。投递权重已改为**均衡**（见 `PROFILE.md`）。  
> 样本：猎聘/公开云原生运维开发、容器平台、K8s 平台研发 JD（2026-07～08）+ 本仓 07-31 雷达。  
> **非全市场爬取**；用于补题与图谱热点，不改八维权重。

## 1. 高频技能词（按出现感排序）

| 权重感 | JD 原文常见说法 | 面试要能讲清什么 | 本仓原状 | 本轮动作 |
|--------|-----------------|------------------|----------|----------|
| 极高 | Kubernetes 架构 / 核心组件 | apiserver / scheduler / controller-manager / etcd 职责与边界 | R1-Q16 半会 | 保持；合面加压 |
| 极高 | 大规模集群稳定性 / 排障 | CrashLoop/OOM/NotReady、oncall | Q09/Q19 | 保持 |
| 极高 | Go（或 Java/Python）运维开发 | 并发、小工具、Informer 直觉 | Go 摸底+Q13 | FZ3/4 按排期 |
| 极高 | Docker + **containerd / CRI / OCI** | kubelet→CRI→containerd→runc 链路 | **缺口** | **R1-Q21 + 笔记** |
| 高 | CNI / CSI / Device Plugin | 现象级排障 + 插件边界 | Q15 会；CSI 故事未测；Device Plugin 弱 | Q15 保持；**Q22 补 Device Plugin/GPU 口述**；CSI 故事卡 |
| 高 | Operator / CRD / controller | List-Watch + 调谐 | Q13 半会 | 保持加深 |
| 高 | etcd 性能 / HA（现象） | 压力症状、备份、不脑裂深挖也可 | 观察维可后置 | 图谱标「常考」；合面一句 |
| 高 | 调度 / 混部 / QoS / cgroup | 你强项 | Q06/Q14/故事 | 保持 |
| 高 | Prometheus / 可观测 | 你强项 | Q10 | 保持 |
| 中↑ | **Kata / 安全运行时 / RuntimeClass** | runc vs 轻量 VM 隔离对比 | P 轨有、题包无独立题 | **并入 Q21**；链 `07-projects/kata-containers` |
| 中↑ | GPU / vGPU / 训推调度 | 污点/亲和/Device Plugin | 弱 | Q22 |
| 中 | ServiceMesh / eBPF / Cilium | 加分 | 冷门/弱 | 仍可后置 |
| 中 | 多集群 / 联邦 | 加分 | 观察维 | 可后置 |
| 中 | RBAC / 镜像安全 / Falco | 合规一句 | 弱 | 观察；不主攻 |
| 低～中 | FinOps / 成本 | 加分 | 无 | 可后置 |

## 2. 你举的例子 → 落点

| 例子 | 训练落点 |
|------|----------|
| 熟悉 K8s 组件 | R1-Q16 + Pod 创建 R1-Q17；合面追问 etcd/调度 |
| containerd | R1-Q21；与 Docker Engine 退场叙事对比 |
| kata 区别 | R1-Q21：runc（共享内核）vs Kata（独立内核/轻量 VM）；RuntimeClass；链 P 轨诚实边界 |

## 3. 题包增补清单（本轮已落）

| 题号 | 主题 | 状态 |
|------|------|------|
| R1-Q21 | CRI / containerd / runc / Kata·RuntimeClass | 未测 · 新 |
| R1-Q22 | Device Plugin / GPU 调度口述（现象级） | 未测 · 新 |
| R1-Q20 | SNAT/DNAT | 标签改为「运维开发同构·多厂」 |

## 4. 训练节奏建议（不改 FZ）

1. 当前 FZ1：网络特训收口 → **Q21**（运行时对比，JD 极高频）→ 再跨主机/VTEP  
2. 同域可插 **Q22**（若投 AI/基座岗则优先）  
3. FZ5 / 故事：CSI、混部、Kata（有真实经历才深挖 P 轨）  
4. **不再**因京东多抽 Q20；Q20 仍保留（多厂运维开发通用）

## 5. 与「均衡权重」的关系

- 技能词来自**多厂 JD 并集**，不是某司考纲。  
- 短模抽题：按缺口与热点，不按公司名加权。

## 6. 补丁（2026-08-05 脉脉 2 帖）

详见 [`2026-08-05-maimai-scheduling-jds.md`](2026-08-05-maimai-scheduling-jds.md)。

| 上调 | 动作 |
|------|------|
| Scheduler Filter/Score/抢占 | R1-Q23 |
| Etcd 够用级 | 笔记 + 热点升高频 |
| 混部/QoS（岗 B 核心） | FZ5 不变，合面加压 |
| Koordinator/Volcano/Kruise | 薄册定位 |
| Go | 仍 FZ3/4；投调度研发可申请提前 |
