# 模拟记录｜面次：一面短模｜日期：2026-07-31

口令等价：`开始模拟`（短模约 25～30min，5 题闭卷）。

## 总分

| 维度 | 分 (1-5) |
|------|----------|
| 技术深度 | 3.2 |
| 表达结构 | 3.0（中后段口语/转写乱，要点仍在） |
| 与岗位匹配 | 3.5（排障手感有；QoS 定义有硬伤） |

过关参考：技术深度 ≥ 3.5 且无硬伤 → **本场未过关**（差在 QoS 硬伤 + 均分）。

## 逐题

| 题号 | 分 | 硬伤？ | 备注 |
|------|----|--------|------|
| Q1 Service 不通 | 4 | 否 | Ready→EP→kube-proxy→网络；可补 port/targetPort |
| Q2 滚动 5xx | 3 | 否 | 点到新未就绪老已删；缺 Ready 曲线 vs maxUnavailable 区分 |
| Q3 requests/limits/QoS | 2.5 | **是** | BestEffort 说成「只配 request 或 limit」；应为都未配 |
| Q4 Taint/Affinity | 3 | 否 | GPU 配合意思对；Toleration 归属说糊 |
| Q5 CrashLoop 路径 | 3.5 | 否 | describe+liveness+OOM 曲线有；缺 previous/退出码前置 |

## 经历故事是否用上

- 用到的故事卡：无强 STAR；偏通用排障
- 缺失的量化/细节：滚动 5xx 无「看 Ready 副本数」证据句

## 下次只补

1. **QoS 三档定义**（尤其 BestEffort = 无 request 且无 limit）——必回炉  
2. 滚动发布：Ready 假就绪 vs maxUnavailable 过大  
3. CrashLoop：事件 → 当前/上次日志 → 退出码 → 再分探针/OOM/业务  

## 等价后续口令

- `错题回炉`（先 QoS）  
- 或再约一次短模（过关线同上）
