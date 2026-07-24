# K8s / 平台关键流程熟练度

面试官选人时看你能不能**按时序串起来**，而不是背名词。  
与 `MINDSETS.md` §3.5「流程能串」对应；宁多勿漏，开卷可逐条自评。

口令：`看流程清单` / 对练时助手抽一条追问「下一步发生什么」。

## 必须能串（L3 向）

| ID | 流程 | 你应能说出的节拍 | 姊妹追问（举一反三） |
|----|------|------------------|----------------------|
| F-01 | **Pod 创建** | 写入 apiserver/etcd → 调度绑定 → kubelet 拉镜像/造沙箱 → 网络/存储插件 → 跑容器 → Ready | 创建失败卡在哪一层？Pending 看什么？ |
| F-02 | **Deployment 滚动** | 新 RS → 起新 Pod → Ready → 缩老 Pod；maxSurge/Unavailable | 对比：暂停滚动 vs 流量灰度 |
| F-03 | **Service 选端** | selector → Endpoints → kube-proxy 转发 | 不通时分层；iptables vs ipvs |
| F-04 | **探针与摘流** | readiness 摘流量；liveness 重启 | 误配导致重启风暴 |
| F-05 | **排障主路径** | 事件 → describe → 日志 → 节点/网络/存储 | CrashLoop vs OOM vs NotReady |
| F-06 | **List-Watch / 事件消费** | List 打底 + Watch；断线重建；限流去重 | 对比裸轮询；事件风暴 |
| F-07 | **CSI 挂载直觉** | 供给/挂载大致谁做；失败先看啥 | controller vs node plugin |
| F-08 | **资源与驱逐** | request 调度；limit 上限；压力下 QoS | 混部干扰与 cgroup |

## 加分（L3 边界 / L4 向）

| ID | 流程 | 深度 |
|----|------|------|
| F-09 | Scheduler 过滤/打分 | 点到即可；不要求背算法 |
| F-10 | 准入 Webhook | 知道在 apiserver 路径上；证书/超时风险 |
| F-11 | 控制器 reconcile | 期望 vs 实际；幂等；与运维自动化区别 |

## 自评

| ID | 会 / 半会 / 不会 |
|----|------------------|
| F-01 |  |
| F-02 |  |
| F-03 |  |
| F-04 |  |
| F-05 |  |
| F-06 |  |
| F-07 |  |
| F-08 |  |
