# 面试挂钩：kata-containers

> 只写真实做过或能诚实讲边界的内容。与 `00-profile/STORY-CARDS.md` 同步。

## 可挂故事卡

| 故事 | 挂钩点 | 一句话 |
|------|--------|--------|
| **S6**（待填）物理机 Kata 治理 | Stats/Update、双通道 | 节点 Agent 用 containerd 读 Guest cgroup、改 pids，VMM 单独看 monitor |
| S2 cgroup | K13 双层 cgroup | Host 管 VMM，Guest 管业务；和混部 cgroup 经验可互证 |
| S5 监控排障 | K12/K21 | 曾把 Host 指标当业务 → 改走 Stats 路径 |

## 技术深挖追问（3 层）

### Q1：你们怎么采 Kata 容器 CPU？

- **L1：** containerd Stats，不是 cadvisor 扫 Host。  
- **L2：** shim → vsock StatsContainer → Guest cgroup；Counter 差分算利用率。  
- **L3：** VMM CPU 在 Host `kata_*` 或 monitor；和 PodOverhead、sandbox_cgroup_only 怎么拆账。

### Q2：怎么动态改 pids.max？

- **L1：** Task.Update，不用 exec 写文件。  
- **L2：** UpdateContainer → agent set pids.max；可能失败若 current > max。  
- **L3：** 与 K8s limits、static_resource_mgmt、多容器 Pod 各容器独立 id。

### Q3：kata-monitor 和你们的 Agent 关系？

- **L1：** 分工：Agent 业务 cgroup，monitor 基础设施。  
- **L2：** monitor 走 HTTP→shim sock，不替代 Stats。  
- **L3：** Prometheus 里 recording rule 怎么避免混 series；多租户权限为何不能给 vsock。

## S6 草稿：物理机 Kata workload 治理

- **S**：节点混跑 Kata Pod，要做 pids/CPU 监控与限流，原方案扫 Host cgroup 偏差大。  
- **T**：准确容器级指标 + 可动态改 pids.max，且不破坏 containerd 边界。  
- **A**：Agent 接 containerd SDK ListTasks/Stats/Update；Kata 分支走 Stats 到 Guest cgroup；VMM 用 monitor 单独大盘；节点配置登记 hypervisor/cgroup 策略。  
- **R**：待补全（指标对齐率、误告警下降等）。  
- **反思**：待补全（若重来是否更早做 RuntimeAdapter）。

## 与 FZ 排期

- FZ2 可口述：Stats vs monitor、OOM 分层。  
- FZ5 深挖：Guest vs Host cgroup，挂 S2。  
- 合面前：S6 STAR + Q1–Q3 闭卷。
