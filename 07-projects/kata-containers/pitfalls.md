# 常见坑汇总：kata-containers

> 速查。分章细节见各 `NN-*.md`。

| # | 坑 | 正确做法 |
|---|-----|----------|
| 1 | 说 Kata 是「微内核」 | Guest 是 **完整 Linux 内核** |
| 2 | 以为只有 Host/Guest 两层 | **三层**：Host / VM(Guest OS) / 容器 |
| 3 | 用 Host `kata_*` cgroup 计费业务 | **Guest Stats** + container id |
| 4 | 只用 kata-monitor 做 pids/账单 | **StatsContainer** 路径 |
| 5 | cadvisor 当 Kata 唯一数据源 | CRI/containerd Stats；VMM 单独看 |
| 6 | sandbox id 调 Stats/Update | 用 **业务 container id** |
| 7 | Exec 写 cgroup 文件改 limit | **Task.Update** |
| 8 | 生产直连 agent vsock | **containerd SDK** |
| 9 | tc ingress = K8s Ingress | 内核 L2 转发 vs L7 路由 |
| 10 | 一容器一 Host veth | **一 Pod** 一套 veth/tap |
| 11 | Host veth 与 Guest eth0 无关 | 同 Pod 管道两端（tc/tap/virtio） |
| 12 | Stats 返回已是分钟平均 | **快照**；Counter 自行差分 |
| 13 | Update memory 一定热扩 VM | 看 **static_resource_mgmt**；**无 sandbox-memory 勿开 static** |
| 14 | limits.memory 全给业务 | 减 **PodOverhead** + VMM；Kata VM = **default + Σ容器** |
| 15 | apiserver 在容器启动链里 | 节点链：**kubelet→CRI→containerd→shim** |
| 16 | CreateSandbox 一次性申请 Σ 容器内存 | K8s 默认 **每 CreateContainer 后 updateResources 热插差额** |
| 17 | VM OOM 重启会再向 Host 要内存 | 目标不变则 **ResizeMemory 跳过**；VM 池复用 |
| 18 | Kata 3.0.0 = architecture 3.0 生产栈 | 默认仍 **Go virtcontainers + 外挂 CLH**；3.0 文档指 runtime-rs |
| 19 | sandbox-memory = PodOverhead | sandbox-memory = **Σ 容器 limit**；Overhead 单独在 RuntimeClass |
| 20 | CLH/QEMU 会缩 VM 内存 | **只扩不缩**；删 Pod 才释 Host RSS |

## 排障顺序（资源）

1. Guest Stats：throttle？pids？memory OOM？  
2. limits vs 实际 usage  
3. Host：VMM 是否抢 CPU（monitor / Pod cgroup）  
4. PodOverhead / sandbox_cgroup_only 配置  

## 排障顺序（网络）

1. Guest：eth0、路由、DNS  
2. Host sandbox ns：veth、tap、tc filter  
3. VMM 是否运行  
4. CNI / NetworkPolicy  
