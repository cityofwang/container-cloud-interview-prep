# K8s 排障三路径：CrashLoop / OOM / NotReady

- 维：C2（兼 C1）｜题：R1-Q09 / **R1-Q19**｜热点：必会｜场景：排障路径  
- 状态：半会（2026-07-30：有现场手段；须补标准路径+互判）

> 面试要的是**固定路径 + 互判**，不是背命令清单。

## 1. 结论背板

| 现象 | 一句话 | 先看什么 |
|------|--------|----------|
| CrashLoopBackOff | 容器反复启动失败 | 日志 + 退出码 + 事件 |
| OOMKilled | 超内存被杀 | Reason/OOM + limits vs 实际用量 |
| Ready=False | 进程可能在，但不接流量 | readiness 失败原因 |

## 2. 三条标准路径（口述用）

### CrashLoopBackOff

1. `describe` 事件：Failed/BackOff/探针杀？  
2. 当前日志 + **上次**容器日志（`--previous`）  
3. 退出码：1 应用错 / 137 常关联杀（含 OOM）/ 探针杀看事件  
4. 启动命令、配置、权限、依赖是否就绪  
5. 是否其实是 OOM 或 readiness/liveness 配错  
6. 区分：应用 bug vs 环境（密钥/DNS/下游）

### OOMKilled

1. 事件 Reason / 退出码 137 线索  
2. 容器 limits 与观测到的内存（若有监控）  
3. 限额过小 vs 泄漏/峰值  
4. 节点压力是否连带驱逐  
5. 处置：提 limit / 修泄漏 / 降并发；不要只「重启试试」

### NotReady（Ready=False）

1. Pod conditions：Ready 消息  
2. readiness 探针：路径/端口/超时是否过严  
3. 进程是否 listen；依赖是否抖动导致探针失败  
4. **Running ≠ Ready**：可存在「活着但不进 Service Endpoints」  
5. 对比 CrashLoop：NotReady 常常**不退出**，只是不接流量

## 2.5 和「现场土方法」怎么摆（运维向加分）

| 你的手段 | 放哪一层 | 面试怎么说 |
|----------|----------|------------|
| `sleep` 很大再手动起进程 | CrashLoop **取证加深** | 「先看日志/退出码；复现困难时再临时改启动命令进容器看报错」——别当第一步 |
| 宿主机 `journalctl -k` | OOM **节点侧加深** | 「K8s 事件已是 OOMKilled 后，若要看内核杀谁，再上节点看」——别跳过 limits |
| 对端口/探针 | NotReady **主路径** | 这点和标准答一致，保留 |

## 3. 对比（易混）

| 对比 | 怎么分 |
|------|--------|
| CrashLoop vs OOM | OOM 是死因之一；先看 Reason/退出码再下结论 |
| CrashLoop vs NotReady | 前者反复重启；后者可稳定 Running 但不 Ready |
| Running vs Ready | 调度成功≠业务可接流量 |

## 4. 自测

1. 口述 CrashLoop 六步，不看笔记。  
2. 给一个「Running 但 Service 无 Endpoints」的现象，你先查 Ready 还是先查 selector？  
3. 对比：只扩 limit 不查泄漏，面试官可能怎么追问？

## 5. 关联

- 题：R1-Q09、R1-Q19、R1-Q11（Endpoints 与 Ready）  
- 图谱：排障与可观测 · CrashLoop/OOM/NotReady  
- 错题：入库后按 3/7 回炉  
