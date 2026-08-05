# 容器出网 SNAT 与 Service DNAT

- 维：C1｜题：R1-Q20（挂钩 Q11/Q18）｜状态：补题已落（2026-07-31）；网络特训续（2026-08-04/05）
- 题源：运维开发面经同构（Docker 网络 → SNAT/DNAT → Service；多厂通用）

> 一面总句：**出网常改源（SNAT）保证回得来；访问 Service 常改目的（DNAT）打到 Pod。**  
> kube-proxy 维护的是后者这类规则；先看 Endpoints，再怀疑规则。  
> **默认 bridge 逐跳（组件级）：** 见 `docker-bridge-packet-path.md`。  
> **镜像/rootfs/containerd：** 见 `container-image-layers-rootfs.md`、`containerd-what-it-does.md`。

---

## 1. 两张图

### 出网（有去有回）—— Docker 默认 bridge 细路径

```text
容器网卡(eth0) ──veth──► docker0 ──转发──► 宿主机路由
  → nat/POSTROUTING: MASQUERADE（SNAT）源=容器IP → 源=宿主机IP
  → 物理网卡 → 外网

回程：外网 → 宿主机IP:端口
  → conntrack 按同一连接做反向还原（不是你另配一条「DNAT 规则」）
  → 目的改回容器IP → docker0 → veth → 容器
```

托管/云网络实现各异；面试说清「为什么要 SNAT」+「回程靠 conntrack」即可。

**易错：** 回程不要说成「再做一次 DNAT」——那是入站发布（`-p` / Service）的术语区；出网回程是 SNAT 会话的反向。

### 访问 ClusterIP（去程）

```text
客户端 Pod A → ClusterIP:port
  → A 所在节点（常见）内核规则（kube-proxy 维护的 iptables/ipvs）
  → 选中后端 B，DNAT：dst → B_IP:targetPort（conntrack 记下）
  → 目的已是真实 PodIP：
       · 同节点：节点本地路由/桥 → B 的 veth → 进 B（未必走 Calico BGP/VXLAN）
       · 跨节点：交给 CNI（如 Calico：常 BGP 直连或 VXLAN 封装）→ B 所在节点 → 进 B
```

### DNAT 之后回程（必会）

```text
后端 B 回包：src=B_IP，dst=A_IP（客户端 PodIP，一般不再改成 ClusterIP）
  → 同节点 / 跨节点：仍靠「PodIP 可达」（本机路由或 CNI）送到 A 所在节点
  → 到 A 节点后：conntrack 认出这是刚才那条被 DNAT 过的连接
  → 对称还原：对客户端侧呈现「对端仍是 ClusterIP」（会话对齐）
  → 进 A
```

**一句：** kube-proxy 负责 **VIP→选人+改目的**；改完之后的 **PodIP 互达** 才是 CNI（Calico 等）的主场。回程多数直接回客户端 PodIP，靠 conntrack 对齐，不是「再 DNAT 一次」。

---

## 2. 对比表

| | SNAT（出网直觉） | DNAT（Service 直觉） |
|--|------------------|----------------------|
| 改什么 | **源**地址 | **目的**地址 |
| 为何 | 回程路由/连通 | 把 VIP 转到真实 Pod |
| 谁相关 | 节点出网、出网 NAT | kube-proxy + Endpoints |
| 回程 | conntrack 反向还原进容器 | conntrack 对称；后端多直接回 **客户端 PodIP** |

| 角色 | 干什么 | 不干什么 |
|------|--------|----------|
| Service | 稳定 VIP + selector | 自己不转发数据包 |
| Endpoints(/Slice) | VIP 背后那组就绪 PodIP:port | 不负责跨主机传包 |
| kube-proxy | 写规则：选后端 + DNAT（现代模式不经用户态转发） | 不负责 Pod 子网互通 |
| CNI（如 Calico） | PodIP 可达（IPAM + 路由/封装） | **不负责** VIP→Pod 的选人 |

### 「容器包互传 = Calico？」——准确说法

| 场景 | 谁主责 |
|------|--------|
| A 访问 ClusterIP | kube-proxy：选 Endpoints + DNAT |
| DNAT 后 dst 已是 B 的 PodIP，同节点送达 | 本机网络栈 / veth（CNI 配好了网卡与路由即可） |
| DNAT 后跨节点送到 B | **CNI**（Calico BGP / VXLAN 等） |
| A 直接访问 B 的 PodIP（不经 Service） | **几乎全程 CNI**（+ 本机） |
| Endpoints 为空 | **先 Ready / 端口 / selector**，不是先查 Calico |

---

## 3. 排障顺序（和 Q11 一致）

1. 目标 Pod Ready？端口 listen？  
2. Endpoints 有没有地址？selector/port 对不对？  
3. 再谈节点规则 / 模式（iptables vs ipvs）  
4. 跨主机不通 → 再下到 CNI 现象（Q15），不先开源码  

**Endpoints 为空：** 优先 Ready / 端口 / selector；**不是**先查 CNI。

---

## 4. 30 秒背板

> 出网要有去有回，节点侧常 SNAT；Service 用 ClusterIP，转发时 DNAT 到 Pod。  
> 不通先看有没有后端，再看规则装没装上。  
> DNAT 后目的是 PodIP；送到 Pod 靠路由+CNI；回程多回客户端 PodIP，靠 conntrack 对齐会话。  
> **VIP 选人 ≠ CNI；PodIP 互达才是 CNI。**
