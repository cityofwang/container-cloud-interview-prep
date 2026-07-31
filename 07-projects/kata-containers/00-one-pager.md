# 一页纸：Kata Containers

> 脱离源码可读。路径索引见 `sources.md`。

## 1. 结论背板（30 秒）

**Kata** 在 K8s 节点上为每个 Pod 起一个 **轻量 VM（VMM + Guest Linux 内核）**，在 Guest 里再用 **namespace/cgroup** 跑业务容器。  
相对 runc：**隔离更强（VM 边界）**，**开销更大（VM 底噪 + 启动慢）**。  
标准路径：`kubelet → CRI → containerd → kata shim v2 → 起 VM → kata-agent → 建容器`。  
**一 Pod 一 VM**；Pod 内多容器 **共享同一 VM** 和 Guest 网络。

## 2. 三层环境

```text
┌─────────────────────────────────────────────────────────────┐
│ Host（节点）                                                 │
│  containerd · kata shim v2 · QEMU/CH/FC · virtiofsd         │
│  Host cgroup: kata_<sandbox>（VMM/shim/vCPU，非业务用量）      │
│  sandbox netns: CNI veth + tap + tc                         │
└───────────────────────────┬─────────────────────────────────┘
                            │ KVM + virtio (net/fs/blk) + vsock
┌───────────────────────────▼─────────────────────────────────┐
│ Guest VM（轻量 Linux 内核 + kata-agent）                     │
│  Guest Pod netns: virtio eth0                               │
│  Guest cgroup: 按 container_id（业务 CPU/mem/pids）          │
└───────────────────────────┬─────────────────────────────────┘
                            │ namespace/cgroup
┌───────────────────────────▼─────────────────────────────────┐
│ 业务容器（nginx、app…）                                      │
└─────────────────────────────────────────────────────────────┘
```

**易错：** 不是「微内核」—— Guest 是 **完整 Linux 内核**；不是两层而是 **三层**。

## 3. 核心组件

| 组件 | 位置 | 职责 |
|------|------|------|
| containerd | Host | CRI 实现、镜像、Task 生命周期 |
| **shim v2** | Host | **一 Pod 一个**长驻进程；起/管 VM；实现 Task API |
| **VMM**（QEMU 等） | Host 进程 | 模拟/半虚拟设备；读写 TAP、virtio-fs |
| **kata-agent** | Guest | 等价 Guest 内 runtime：Create/Start/Stats/Update/Exec |
| virtiofsd | Host | 把 Host 目录共享进 VM（常见 rootfs 路径） |
| kata-monitor | Host（可选） | HTTP `/metrics` → shim，**基础设施指标** |

## 4. 控制面 vs 数据面

| 面 | 通道 | 承载 |
|----|------|------|
| **控制** | vsock（或 hvsock）+ **ttrpc** | CreateContainer、StatsContainer、UpdateContainer |
| **数据** | virtio-net、virtio-fs、virtio-blk | 业务流量、文件、块 I/O |

**易错：** kata-monitor **不**直连 vsock；它走 **Unix socket → shim**。

## 5. 与 runc / 通用 K8s 对比

| 维度 | runc | Kata |
|------|------|------|
| 隔离 | Host namespace | **VM +** namespace |
| 业务进程在哪 | Host cgroup 树 | **Guest** cgroup 树 |
| Pod 网络 eth0 | Host netns | **Guest** netns |
| 启动 | 快 | 慢（VM boot） |
| 监控默认路径 | cadvisor 常够用 | 必须 **Guest Stats** 路径 |
| 密度 | 高 | 低（+PodOverhead） |

## 6. 一 Pod 多容器

```text
1 Pod → 1 sandbox id → 1 VM → 1 shim → 1 agent
         ├─ container_id: pause
         ├─ container_id: app
         └─ container_id: sidecar
```

- **Stats/Update/Exec** 参数用 **各业务 container id**，不是 sandbox id。
- Host 上通常 **一套 veth/tap/Pod 管道**，不是每容器一套。

## 7. 你的物理机服务应记住

| 要做 | 推荐 | 避免 |
|------|------|------|
| 读 CPU/mem/pids | containerd **Task.Stats** | 只扫 Host `kata_*` cgroup |
| 改 pids.max/quota | containerd **Task.Update** | Exec 写 cgroup 文件 |
| 看 VMM 开销 | kata-monitor 或 Host Pod cgroup | 当业务账单 |
| 生产控制 | containerd Go SDK | 直连 agent vsock |

## 8. 面试一句

「我们节点上对 Kata workload 做治理时，**容器级指标走 containerd Stats 到 Guest cgroup**；**VM/shim 开销单独看 monitor 或 Host cgroup**；改规格走 **Task.Update** 到 agent，不碰 Host 业务 cgroup。」

## 9. 自测（先答后讲）

1. Kata 三层分别是什么？业务进程的 pid 在哪一层？
2. 为什么说「一 Pod 一 VM」？sidecar 和 app 几个 VM？
3. vsock 和 virtio-net 分别干什么？
4. 你的 Agent 为什么应连 containerd 而不是 agent？
5. **对比：** runc 与 Kata 下 `kubectl top pod` 的数据从哪来（概念层）？

<details>
<summary>参考要点（先自答再看）</summary>

1. Host / Guest VM / Guest 容器；业务 pid 在 Guest 容器层。  
2. 一 Pod 一 sandbox/VM；多容器共享同一 VM。  
3. vsock=控制 RPC；virtio-net=业务网络数据面。  
4. 权限边界、多租户、API 稳定、与 CRI 一致。  
5. 都依赖 CRI/containerd 统计；Kata 时 shim 经 vsock 读 **Guest cgroup**，不是 Host 上业务进程 cgroup。
</details>

## 10. 关联

- KNOWLEDGE-MAP：C1 隔离、C1 Pod 创建、C2 可观测  
- 下一章：`03-observability.md`  
- 坑汇总：`pitfalls.md`
