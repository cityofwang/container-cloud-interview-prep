# 设计稿：K8s Warning 事件自动处置（防风暴）

- 维：G3 / C2｜错题：GO-D-09｜场景族：SCE-02  
- 用途：**面试项目讲解稿**（设计能讲透）；非生产级完整仓库  
- 深度：L3 够用；真要落地代码另开 demo

## 1. 一句话结论

用 Go **消费可行动 Warning 事件**做重启/扩容等运维动作时，必须用 **去重 + 限频 + 动作冷却/幂等 + Reason 白名单 + 熔断转人工**，避免事件风暴打崩集群；这是 **旁路自动化**，不是再写一个 Deployment 控制器。

## 2. 目标 / 非目标

| 要做 | 不做 |
|------|------|
| 对白名单 Reason 做有限自动止血 | 自动重启物理机、无界狂扩容 |
| 削峰、可观测、可熔断 | 替代官方控制器调谐 |
| 设计能讲清、可演进 | 一上来微服务中台全家桶 |

处置对象默认：**工作负载/Pod 侧**（restart/scale）；节点类以告警+隔离建议为主。

## 3. 逻辑架构

```text
K8s events (List-Watch)
    → Ingest（过滤 Type=Warning、白名单 Reason）
    → 聚合/去重窗口（稳定 key）
    → 队列（可选，削峰）
    → Dispatcher（查动作账：冷却/熔断）
    → Actor（调 API：rollout restart / scale …）
    → 写动作账 + 指标/日志
    → 熔断时：只告警 + 工单，不改集群
```

对比：**同步每条 event 立刻改集群** vs **窗口聚合后再决策** —— 选后者。

## 4. 去重 key 与 MESSAGE

真实事件含 Reason / Object / Message。

- **主键建议：** `Reason + 涉及负载身份`（如 Deployment 的 ns/name；Pod 事件上浮到所属负载）  
- **可选加稳定抽取字段：** 镜像名、错误码（从 MESSAGE 解析）  
- **不要**用整句 MESSAGE 当 key（易因文案抖动失效）  
- MESSAGE：**进日志/告警详情**；不作为每次动作的触发条件

聚合窗口示例：1～5 分钟同 key 只产生 **一次可行动信号**。

## 5. 两本账（冷却 / 幂等靠动作账）

**事件账（ingest）**  
- key → 窗口内次数、上次处理时间  
- 用途：去重、限频（如 60min 内最多 N 次进入处置）

**动作账（action）**  
- 目标 + 动作类型 → 上次执行时间、连续失败次数、是否熔断  
- 用途：冷却（同 Deployment 重启间隔）、幂等（风暴中只动一次）、熔断判定  

多副本部署时动作账需 **共享存储**（Redis/DB/Lease 等），避免各实例各冷各的。

## 6. 白名单 × 熔断 × 人工

```text
事件 → 白名单？否→忽略
     → 去重/限频
     → 已熔断？是→仅告警/工单
     → 执行动作 → 更新动作账
```

| 闸门 | 作用 |
|------|------|
| Reason 白名单 | 这类事件**允不允许**自动碰集群 |
| 熔断 | **此刻暂时禁止**自动，转人工 |

**转人工示例：** 冷却内仍反复失败；API 持续失败；影响面过大；限频连续命中；未知 Reason。

## 7. 与「控制器调谐」的边界

| 控制器 reconcile | 本设计 |
|------------------|--------|
| 持续对齐 spec/status | 事件触发的运维反应 |
| 声明式期望 | 策略式止血（限流后的重启/扩容） |
| 官方/Operator 主路径 | 旁路，勿抢调谐 |

面试句：我做事件驱动运维自动化，不是第二个 Deployment controller。

## 8. 和亿级邮件同构

同一肌肉：有限下游（apiserver/集群）+ 海量信号 → 队列/聚合 → worker 限流 → 幂等 → 观测 → 熔断降级。  
换皮：全集群回填、遥测风暴（见 `05-scenario-line` SCE-05…08）。

## 9. 最小接口草图（口述够用）

```go
type EventKey struct { Reason, Namespace, Name string /* + optional StableAttr */ }

type ActionRecord struct {
    Target    string
    Action    string // restart|scale
    LastAt    time.Time
    FailStreak int
    Tripped   bool // 熔断
}

// Handle(ev): whitelist → dedupe → check ActionRecord → act → save
```

List-Watch 断线：退避重连 + 可重新 List 打底；仍受 QPS/限流约束。

## 10. 自测口述

1. 为何不用整句 MESSAGE 做去重 key？  
2. 白名单和熔断谁先谁后？  
3. 和 Deployment 控制器有何不同？

## 关联

- GO-D-09、SCE-02、S3 故事卡  
- 笔记：`go-goroutine-leak`（worker 必须可取消）  
- 流程：`PROCESS-FLOWS.md` F-06
