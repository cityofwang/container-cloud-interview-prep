# 一面题包（第一批）

开卷先自评，再闭卷模拟。每题按：结论 → 原理要点 → 你怎么做/怎么查。

## R1-Q01 Docker 与 VM；namespace / cgroup

**题目：** 容器和虚拟机核心差别是什么？Linux namespace 与 cgroup 分别解决什么问题？

**参考答法要点：**
- VM：硬件级虚拟化，独立 Guest OS；隔离强、启动重、密度低
- 容器：共享宿主机内核；用 namespace 做隔离视图，用 cgroup 做资源限制
- namespace 常见：pid/net/mnt/uts/ipc/user ——「看见什么」
- cgroup：cpu/memory/io/pids 等 ——「能用多少」
- 一句话：隔离看 namespace，配额/保障看 cgroup

**追问：** 为什么容器逃逸危险？混部场景为何更依赖 cgroup？

**挂钩提示：** S2（cgroup）；可带一句混部为何要限制干扰（S1）

## R1-Q02 Pod 是什么

**题目：** 为什么 K8s 调度与管理的最小单位是 Pod 而不是容器？同 Pod 内容器共享什么？

**参考答法要点：**
- Pod = 共享网络与存储命名空间的一组容器（通常强耦合）
- 同 Pod：同一 IP/端口空间、可 localhost 通信、可共享 volume
- pause/infra 容器持有网络命名空间（实现细节可提一层）
- 边车模式：代理、日志、加固与主容器同生命周期

**追问：** 什么时候不该把两个进程塞进同一 Pod？

**挂钩提示：** 排障时先确认问题在容器内还是 Pod/节点层（S5）

## R1-Q03 工作负载控制器

**题目：** Deployment / StatefulSet / DaemonSet 怎么选？

**参考答法要点：**
- Deployment：无状态、可互换副本、滚动更新；Web/API
- StatefulSet：稳定身份、有序扩缩、每实例存储；ZK/Etcd/部分中间件
- DaemonSet：每节点（或选中节点）一个；日志 agent、node exporter、部分网络/存储插件
- Job/CronJob：跑完就走 / 定时（一面能点到即可）

**追问：** CSI node plugin 为何常见 DaemonSet？

**挂钩提示：** S4（CSI 部署形态）

## R1-Q04 Service 与 Ingress

**题目：** ClusterIP / NodePort / LoadBalancer 差异？和 Ingress 如何分工？

**参考答法要点：**
- Service：稳定虚拟 IP + kube-proxy/IPVS 转发到 Endpoints/EndpointSlice
- ClusterIP：集群内；NodePort：节点端口；LB：云厂商负载均衡挂到节点/Pod
- Ingress：HTTP(S) L7 路由（主机/路径/TLS），背后仍落到 Service
- 选型：东西向 ClusterIP；暴露 HTTP 常用 Ingress；非 HTTP 或简单暴露用 LB/NodePort

**追问：** Service 选不到 Pod 时怎么查（label/selector/endpoints）？

**挂钩提示：** S5 网络类排障入口

## R1-Q05 ConfigMap 与 Secret

**题目：** ConfigMap 和 Secret 区别？Secret 安全上要注意什么？

**参考答法要点：**
- 都是配置投递（env/volume）；Secret 面向敏感数据、会 base64（不是加密）
- etcd 中可能近明文；需加密 at rest、RBAC 收紧、少挂载、轮转
- 实践：外置 KMS/密封密钥/禁止打进镜像；权限最小化

**追问：** 误把 Secret 打进镜像或日志怎么发现与补救？

**挂钩提示：** 无强故事则讲规范；有相关经历再挂钩

## R1-Q06 requests/limits 与 QoS

**题目：** requests 与 limits 含义？三种 QoS？对调度和驱逐的影响？

**参考答法要点：**
- requests：调度与资源预留依据；limits：上限
- Guaranteed：request=limit 且都设置；Burstable：未齐或不等；BestEffort：都未设
- 压力下 BestEffort 更先被挤；CPU throttle vs Memory OOM 行为不同
- 混部/干扰治理常从合理 request + limit + 观测开始

**追问：** 只设 limit 不设 request 会怎样？

**挂钩提示：** S2、S1

## R1-Q07 探针

**题目：** liveness / readiness / startup 区别与误配后果？

**参考答法要点：**
- liveness 失败 → 重启容器；readiness 失败 → 摘流量；startup 保护慢启动
- liveness 打到依赖不稳的接口 → 重启风暴
- readiness 过松 → 带病接流量；过严 → 容量假死
- 探针超时/周期要匹配真实启动与依赖

**追问：** 和滚动更新失败有何关系？

**挂钩提示：** S5 发布/告警类

## R1-Q08 滚动更新与回滚

**题目：** Deployment 滚动更新怎么保证可用？如何回滚？如何确认健康？

**参考答法要点：**
- maxUnavailable / maxSurge；新 Pod Ready 再缩老 Pod
- `kubectl rollout status/history/undo`；保留 ReplicaSet
- 确认：readiness、错误率、延迟、事件、关键业务指标
- 变更三板斧：可回滚、可观测、小步灰度（一面点到）

**追问：** 镜像有问题但 Pod Running 的情况？

**挂钩提示：** S5

## R1-Q09 常见异常排查

**题目：** Pending / ImagePullBackOff / CrashLoopBackOff 你的排查顺序？

**参考答法要点：**
- Pending：describe 事件 → 资源/亲和/污点/PVC
- ImagePull：镜像名/权限/网络/凭证
- CrashLoop：日志 → 退出码 → 探针误杀 → 配置/依赖/OOM
- 固定路径：事件 → 资源描述 → 日志 → 节点/存储/网络

**追问：** 如何区分应用 bug 与环境问题？

**挂钩提示：** S3（事件）、S5

## R1-Q10 监控告警与事件驱动

**题目：** 口述一条监控告警链路；如何基于 K8s 事件做运维逻辑？

**参考答法要点：**
- 指标（Prometheus 等）+ 日志 + 事件/链路，告警要可行动
- 事件：Warning/Failed* 等触发通知、enrich、自动止血（需防抖）
- 降噪：聚合、抑制、冷却、只对可行动事件自动化
- 与「控制器调谐」区别：你做的是运维侧反应，不是替换控制面

**追问：** 事件风暴时怎么保证自动化不伤集群？

**挂钩提示：** S3、S5（主故事题）
