# 观测与资源治理：Stats、Monitor、Update

> Kata 项目 · P0 章 · 关联 K12/K15/K16/K21/K22  
> 脱离源码可读。

## 1. 结论背板（30 秒）

Kata 有 **两条独立的观测通道**：

1. **容器 cgroup（业务）**：`containerd Task.Stats` → shim → vsock **StatsContainer** → agent 读 **Guest cgroup** → CPU throttle、memory、pids 等。  
2. **基础设施（VM/shim/guest OS）**：**kata-monitor** `GET /metrics` → shim Unix socket → 可选 agent **GetMetrics** → Prometheus 格式，偏 **/proc、agent、hypervisor**。

**改规格**（pids.max、cpu quota、memory.limit）：`Task.Update` → **UpdateContainer** → agent 写 Guest cgroup。  
**生产 Agent 应接 containerd SDK**，不要生产直连 vsock agent。

---

## 2. 原理：Stats 全链路

```text
kubectl top / crictl stats / 你的 SDK
        │
        ▼
   containerd (CRI StatsContainer / Task.Metrics)
        │
        ▼
   kata shim v2  .Stats(taskID)
        │
        │  ttrpc over vsock
        ▼
   kata-agent  stats_container(container_id)
        │
        ▼
   rustjail / cgroup fs  get_stats()
        │
        ▼
   返回 CgroupStats（cpu/memory/pids/blkio…）
```

**关键语义：**

| 字段类型 | 例子 | 怎么用 |
|----------|------|--------|
| **Gauge** | memory.usage、pids.current | 两次采样可算平均 |
| **Counter** | cpu.usage_total（纳秒） | **Δ值/Δt** 得利用率 |
| **Limit** | memory.limit、pids.limit | 与 Gauge 比做饱和度 |

**无内置「分钟平均」**：每次 pull 是 **快照**；Prometheus/你的 Agent 自己算 rate/avg。

---

## 3. 原理：kata-monitor 链路

```text
curl http://<node>:8080/metrics   (kata-monitor)
        │
        ▼
   Unix socket: shim-monitor.sock
        │
        ▼
   shim 聚合
        ├─ shim / hypervisor 自身指标
        └─ 可选 vsock GetMetrics → guest /proc、agent 内部指标
```

| 特点 | StatsContainer | kata-monitor |
|------|----------------|--------------|
| 入口 | containerd/CRI | HTTP Prometheus |
| 粒度 | **per container_id** | 偏 **sandbox/组件** |
| pids.current / pids.max | ✅ | ❌ 不完整 |
| cpu throttling 细节 | ✅ | 有限 |
| guest meminfo、/proc 统计 | ❌ | ✅ |
| 适合 | **业务 quota、计费、HPA** | **节点大盘、VMM 健康** |

**易错：** monitor **不能**替代容器 cgroup 账单。

---

## 4. 原理：Update 全链路

```text
kubectl edit limits / CRI UpdateContainerResources / SDK Task.Update
        │
        ▼
   shim .Update(taskID, resources)
        │
        ├─ 可能：ResizeVM（vCPU/内存 hotplug，非 static 时）
        │
        ▼
   agent update_container(container_id, LinuxResources)
        │
        ▼
   rustjail cgroup set()
        ├─ cpu.cfs_quota_us / period
        ├─ memory.max
        └─ pids.max
```

**可热更（常见）：** CPU quota/period、memory limit、pids.max（agent 支持子集）。  
**注意：** cpuset 等可能在进 agent 前被 shim 清掉；大改 VM 内存可能走 **热插拔** 而非仅 cgroup。

**static_resource_mgmt=true：** Update 可能 **只改 Guest cgroup**，不改 VM 大小——大规格变更或需重建 Pod。

---

## 5. container id vs sandbox id

| ID | 典型来源 | 用于 |
|----|----------|------|
| **sandbox id** | Pod pause / PodSandbox | 一 VM、Host `kata_<sandbox>` |
| **container id** | 每个容器含 app | Stats、Update、Exec |

```bash
# 概念验证（调试）
ctr -n k8s.io tasks metrics <container_id>
crictl stats <container_id>
```

对 **pause** 调 Stats → 得到 pause 的 cgroup，**不是** nginx。

---

## 6. 使用场景

| 场景 | 用哪条通道 | 说明 |
|------|------------|------|
| 租户 CPU/内存/pids 账单 | Stats | Guest cgroup |
| 触发 pids 告警 | Stats pids.current vs limit | |
| 动态调 pids.max | Update | SDK，带 container id |
| 节点「Kata 吃多少内存」 | monitor + Host Pod/overhead cgroup | 非业务 |
| 诊断 Guest OOM | Stats memory + events；monitor 辅助 | 区分 VM OOM vs 容器 OOM |
| Prometheus 大盘 | 两者都要 | recording rules 分开 |

---

## 7. 对比

### 7.1 接入方式

| 方式 | 优点 | 缺点 |
|------|------|------|
| **containerd Go SDK** | 稳定、权限可管、与 K8s 一致 | 需处理 namespace、Kata/runc 分支 |
| crictl/ctr CLI | 调试快 | 不适合生产定时任务 |
| 直连 agent vsock | 看起来「直连」 | 无调用方身份、绕过 containerd、升级脆 |
| cadvisor | runc 节点省心 | Kata **易读错对象** |

### 7.2 runc vs Kata 监控

| | runc | Kata |
|---|------|------|
| 业务进程 cgroup | Host 上 | Guest 内 |
| cadvisor 直接读 | 常对齐 | **常不对齐** |
| 正确路径 | CRI Stats 即可 | CRI Stats **必须**（shim→agent） |
| 额外开销指标 | 小 | 需 monitor/Host cgroup |

---

## 8. 常见坑

### P1：用 Host `kata_*` cgroup 当业务用量
Host cgroup 上是 **qemu、shim、vCPU 线程**，不是 nginx 的 CPU。

### P2：只用 kata-monitor 做 pids 治理
monitor 没有完整 **pids.max / pids.current** 容器级字段。

### P3：cadvisor 当唯一数据源
cadvisor 扫 Host 树；Kata 业务不在 Host 叶子 → **VMM CPU 误当业务 CPU**。

### P4：sandbox id 调 Stats
拿到 pause 或 sandbox 级数据，张冠李戴。

### P5：Exec 进容器写 cgroup
路径、cgroup 驱动、权限不可靠；应 **Update API**。

### P6：以为 agent 有「分钟平均窗口」
多采集器各算各的；Counter 必须自己差分。

### P7：Update 只改 Host cgroup
不影响 Guest 业务 limit。

### P8：pids.current > 新 pids.max
Update 可能失败，需先降负载或分批。

---

## 9. 生产 Agent 设计要点

```text
RuntimeAdapter
  DetectRuntime(task) → runc | kata
  GetContainerStats(containerID) → 统一模型
  UpdateResources(containerID, LinuxResources)
  GetSandboxOverhead(sandboxID)  // kata: monitor 或 host cgroup
```

1. **ListTasks** + K8s labels 发现 Pod/容器。  
2. **Stats**：Gauge 存序列算 avg；Counter 用 Δ/Δt。  
3. **Update**：幂等、重试、失败告警（pids 超限等）。  
4. **节点基线注册表**：hypervisor、internetworking_model、sandbox_cgroup_only、static_resource_mgmt。  
5. **权限**：containerd.sock 按节点池隔离，不暴露给租户。

---

## 10. 面试挂钩

**L1：** 「Kata 容器指标要从 containerd Stats 进 Guest cgroup，不能只看 Host。」  
**L2：** 「Stats 和 kata-monitor 两条线；前者 pids/throttle，后者 VMM 和 guest /proc。」  
**L3：** 「Update 走 Task.Update 到 agent set cgroup；static 模式下 VM 不一定热扩；PodOverhead 和 sandbox_cgroup_only 影响 Host  cgroup 怎么拆。」

见 `interview-hooks.md`、故事卡 S6。

---

## 11. 自测（先答后讲）

1. 画出 Stats 从 SDK 到 Guest cgroup 的 5 步。  
2. monitor 和 Stats 各适合什么场景？  
3. 为什么 cadvisor 在 Kata 上容易「看错对象」？  
4. 改 pids.max 的正确 API 路径是什么？  
5. **对比：** Counter 和 Gauge 怎么做「分钟平均」？  
6. 多容器 Pod：几次 Stats 调用？参数是什么？

<details>
<summary>参考要点</summary>

1. SDK → containerd → shim.Stats → vsock StatsContainer → agent get_stats → 返回。  
2. Stats=业务 cgroup；monitor=VMM/shim/guest OS。  
3. 业务进程在 Guest，Host 上是 VMM。  
4. containerd Task.Update → UpdateContainer → agent。  
5. Gauge 采样平均；Counter 用两次差分/时间。  
6. 每个关心的 container_id 各调一次（app、sidecar…）。
</details>

---

## 12. 关联

- 上一章：`00-one-pager.md`  
- 坑汇总：`pitfalls.md`  
- 源码索引：`sources.md`  
- KNOWLEDGE-MAP：C2 监控、C3 cgroup  
- 通用笔记：`k8s-troubleshoot-crashloop-oom-notready.md`（OOM 分层）
