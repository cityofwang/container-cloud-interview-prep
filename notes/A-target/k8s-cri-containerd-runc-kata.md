# CRI / containerd / runc / Kata（JD 高频对比）

- 维：C1｜题：R1-Q21｜挂钩 P 轨：`07-projects/kata-containers/`
- 题源：2026-08-04 JD 技能清单（运维开发/容器平台岗高频）

> 一面总句：**kubelet 经 CRI 找运行时；生产多是 containerd；默认创容器用 runc（共享内核）；要更强隔离用 Kata 等 + RuntimeClass。**

---

## 1.5 从 kubelet 到进程起来（节点侧 · 面试口径）

> 范围：本机已有「该 Node 的 Pod」；不讲调度。CRI 调用由 kubelet 发出。

```text
kubelet 同步本节点 Pod
  →（常）挂载 Volume
  → CRI 拉镜像（ImageService）
  → CRI RunPodSandbox：建【沙箱】+ CNI 配网（veth/IP 等多在这一步）
  → CRI 创建/启动 init 与业务容器
       ├─ 默认：containerd → runc（共享宿主机内核）
       └─ RuntimeClass=kata：containerd → Kata（先起轻量 VM，再在 Guest 内起容器）
```

**和易混说法对照**

| 说法 | 更准 |
|------|------|
| 「启动 containerd 容器」 | containerd 是**运行时管理器**，不是一种容器 |
| 先拉镜像再随便起进程再配网 | 配网通常绑在 **Pod 沙箱（pause）** 创建上，业务容器进同一 netns |
| list-watch 直接感知「容器」 | list-watch 的是本节点 **Pod**；kubelet 再对每个 Pod 做同步 |

| 名词 | 是什么 | 面试一句 |
|------|--------|----------|
| **CRI** | Kubelet 与容器运行时之间的**接口标准** | 换运行时不用改 kubelet 核心 |
| **containerd** | 容器管理守护进程；常作 CRI 实现 | 拉镜像、建容器、调底层 runtime |
| **runc** | OCI 运行时：用 namespace/cgroup **起进程容器** | 默认、轻、共享内核 |
| **Kata** | 用轻量虚拟机跑「容器体验」 | 隔离强、开销更大；经 RuntimeClass 选用 |
| **Docker** | 昔日整条引擎；现多「CRI 对接 containerd」 | 别把 Docker 和 containerd 说成毫无关系——历史上 Docker 也用过 containerd |

---

## 2. 对比表（必背）

| | runc（默认） | Kata |
|--|--------------|------|
| 隔离 | namespace/cgroup，**共享宿主机内核** | 每 Pod/沙箱近似独立内核（轻量 VM） |
| 性能 / 密度 | 好、密度高 | 启动与内存开销更大 |
| 安全边界 | 逃逸面相对大（内核共享） | 更强租户隔离 |
| 怎么选中 | 默认 RuntimeClass / 不写 | `runtimeClassName: kata` 等（集群需装好） |
| 和你经历 | 日常托管集群大多这条 | 有 P 轨再讲 Stats/Guest cgroup；**没有就说边界** |

**containerd vs Docker（口述）：**  
K8s 不再依赖 Docker Engine 作为唯一运行时；kubelet → CRI → **containerd** 是主流。本机 `docker` 命令仍可能存在，但是另一条用户工具链，面试以 **CRI 链路**为准。

---

## 3. 排障直觉

| 现象 | 先想哪一层 |
|------|------------|
| 镜像拉不下来 | containerd / 仓库鉴权 / 节点网络 |
| Pod 沙箱创建失败 | CRI / runtime 配置 / RuntimeClass 是否存在 |
| 容器起不来但镜像在 | runc/Kata、cgroup、存储（overlay） |
| Kata 指标不准 | 勿只扫 Host cgroup；见 P 轨 interview-hooks |

---

## 4. 30 秒背板

> CRI 是 kubelet 和运行时的合同；containerd 实现 CRI；默认用 runc 做共享内核容器；要强隔离上 Kata 并用 RuntimeClass 指定。对比就三点：隔离模型、开销、选用方式。

## 5. 岗位向深挖（L2/L3）

### L2：为何要有 CRI

旧链路曾是 `kubelet → Docker Engine → containerd → runc`。Docker Engine 退役后，kubelet **只认 CRI**，下面可接 containerd / CRI-O 等。  
面试口径：CRI = 合同；containerd = 常见乙方；runc/Kata = 真正「把进程/VM 拉起来」的人。

### L3：生产排障分层

| 现象 | 优先怀疑 |
|------|----------|
| ErrImagePull / ImagePullBackOff | 仓库、鉴权、节点出网、containerd 配置 |
| CreateContainerError / sandbox 失败 | RuntimeClass 未装、CNI、磁盘、runtime 配置 |
| runc 正常、Kata 失败 | 虚拟化嵌套、/dev/kvm、Kata 配置、节点标签 |

Kata 指标：业务 CPU/内存在 **Guest cgroup**；Host 上看到的常是 VMM。详见 P 轨 `interview-hooks.md`。

