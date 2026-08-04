# 容器出网 SNAT 与 Service DNAT（京东题感）

- 维：C1｜题：R1-Q20（挂钩 Q11/Q18）｜状态：未测→补题已落（2026-07-31）
- 题源：京东运维开发面经同构（Docker 网络 → SNAT/DNAT → Service）

> 一面总句：**出网常改源（SNAT）保证回得来；访问 Service 常改目的（DNAT）打到 Pod。**  
> kube-proxy 维护的是后者这类规则；先看 Endpoints，再怀疑规则。

---

## 1. 两张图

### 出网（有去有回）

```text
Pod (10.0.1.5) → 外网 1.2.3.4
  → 经节点时源地址常被 SNAT/MASQUERADE 成节点 IP
  → 回程才能回到这台节点再转回 Pod
```

托管/云网络实现各异；面试说清「为什么要 SNAT」即可，不装成改过 iptables 生产规则。

### 访问 ClusterIP

```text
客户端 → ClusterIP:port
  → 节点内核规则（kube-proxy 维护的 iptables/ipvs）
  → DNAT 成 PodIP:targetPort
```

---

## 2. 对比表

| | SNAT（出网直觉） | DNAT（Service 直觉） |
|--|------------------|----------------------|
| 改什么 | **源**地址 | **目的**地址 |
| 为何 | 回程路由/连通 | 把 VIP 转到真实 Pod |
| 谁相关 | 节点出网、CNI/云网络 | kube-proxy + Endpoints |

---

## 3. 排障顺序（和 Q11 一致）

1. 目标 Pod Ready？端口 listen？  
2. Endpoints 有没有地址？selector/port 对不对？  
3. 再谈节点规则 / 模式（iptables vs ipvs）  
4. 跨主机不通 → 再下到 CNI 现象（Q15），不先开源码  

---

## 4. 30 秒背板

> 出网要有去有回，节点侧常 SNAT；Service 用 ClusterIP，转发时 DNAT 到 Pod。  
> 不通先看有没有后端，再看规则装没装上。

自测：SNAT 和 DNAT 各改谁？和 kube-proxy 的关系？
