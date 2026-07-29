# 污点 / 容忍 / 亲和（调度落点）

- 维：C1（挂钩 C3 混部）｜题：R1-Q14｜状态：一面不会→补洞中

> 一面总句：**Taint/Toleration = 节点排斥 + Pod 声明能忍；Affinity = 吸引或相对其他 Pod 的位置偏好。**  
> 和 request/limit 不同：前者管「**能不能/想不想落到这台节点**」，后者管「**占多少资源、争抢时谁先被挤**」。

---

## 0. 推荐口述（约 45～60 秒）

> 调度里常有两套「落点」手段。  
> **污点 Taint** 打在 **Node** 上，表示这台节点默认排斥普通 Pod；Pod 必须带匹配的 **Toleration** 才允许被调度上来。常用于专用池、控制面节点、或临时隔离问题节点。  
> **亲和 Affinity** 是「吸引」或「相对位置」：节点亲和按节点标签选池；Pod 亲和/反亲和按「和其他 Pod 同节点/同拓扑」或打散。  
> 混部里干扰敏感的在线负载，可以用污点+容忍进「在线池」，或用反亲和打散；**只设 request 不够隔离干扰**——request 管配额与驱逐优先级直觉，不管「别和离线批处理挤一台」这种落点策略。  
> 验证就看：Pod 是否落到预期节点、事件里是否 FailedScheduling。

---

## 1. 先分清：谁排斥谁、谁吸引谁

| 机制 | 作用在谁 | 语义 | 典型用途 |
|------|----------|------|----------|
| **Taint** | **Node** | 「我有污点，普通人不来」 | 专用节点、NoSchedule 隔离 |
| **Toleration** | **Pod** | 「我能忍某种污点」 | 只有白名单负载能上脏节点 |
| **NodeAffinity** | Pod 对 **Node 标签** | 必须/希望落在某类节点 | 机型、可用区、池标签 |
| **PodAffinity** | Pod 对 **其他 Pod** | 希望和某类 Pod 在一起 | 同机架、同 AZ 近置 |
| **PodAntiAffinity** | Pod 对 **其他 Pod** | 希望别和某类 Pod 在一起 | 副本打散、隔离噪声邻居 |

```text
          Taint（节点说：滚开）
 Node ────────────────────────► 普通 Pod 调不上来
          ▲
          │ Toleration（Pod 说：我能忍）
          │
        专用 Pod 可以上

 NodeAffinity：Pod 说「我要带 xx 标签的节点」
 PodAntiAffinity：Pod 说「别和 label=batch 的挤一台」
```

---

## 2. Taint / Toleration 机理

### 2.1 污点效果（面试记三个名字即可）

| Effect | 含义 |
|--------|------|
| **NoSchedule** | 新 Pod 无容忍则**不会被调度来**（已在上面的不一定立刻赶） |
| **PreferNoSchedule** | **尽量别来**（软） |
| **NoExecute** | 无容忍则**不调度且可能驱逐**已在节点上的 Pod |

### 2.2 匹配逻辑（直觉）

- Node 上：`key=value:NoSchedule`（value 可空）  
- Pod 上：Toleration 声明能忍相同 key（及 effect 等）  
- **所有**不可容忍的相关污点都过不了 → 调不上来  

系统组件常自带对控制面污点的容忍（如 `node-role.kubernetes.io/control-plane`）。

### 2.3 和「隔开负载」的关系

- 给「在线池」节点打污点 `workload=online:NoSchedule`  
- 只有带对应 Toleration 的在线 Pod 能上  
- 离线/批处理没有容忍 → **调度层就被隔开**  

---

## 3. Affinity 机理

### 3.1 软 vs 硬（required vs preferred）

| | required（硬） | preferred（软） |
|--|----------------|-----------------|
| 满足不了 | **调不上**（Pending） | 尽量满足，不满足也能上 |
| 使用 | 强隔离、强合规 | 优化放置、别太死 |

### 3.2 节点亲和 vs Pod 亲和

- **NodeAffinity**：看 Node 的 labels（`disk=ssd`、`pool=latency-sensitive`）  
- **PodAffinity / AntiAffinity**：看**已经在跑的 Pod** 的 labels + 拓扑键（`kubernetes.io/hostname`、zone…）  
  - 反亲和 + hostname：副本尽量别落同一台机  

### 3.3 混部直觉

- 噪声邻居：在线服务 **AntiAffinity** 避开 `batch=true`，或 offline 打污点只让批处理忍  
- 需要近置：同 AZ **PodAffinity**（注意别和反亲和目标冲突）  

---

## 4. 对比：污点 vs 亲和 vs request（必会）

| | 解决什么 | 不解决什么 |
|--|----------|------------|
| **Taint/Toleration** | 节点默认排斥；白名单才能上 | 上了之后 CPU 抢夺的细节 |
| **Affinity** | 按标签/相对位置吸引或打散 | 同上；硬亲和可能导致 Pending |
| **requests/limits** | 调度预留、限额、QoS/驱逐直觉 | **不能**单独表达「专用池/别和 batch 同机」 |

**追问答法：** 只靠 request **不够**隔离干扰。  
request 让调度器知道要占多少资源，也影响 QoS；但两个人都能被调度到同一节点时，仍可能互相抢（CPU throttle、缓存、磁盘 IO）。混部还要：**池化（污点）/ 打散（反亲和）/ 隔离手段（cgroup、离线压制等，你的强项）**。

---

## 5. 怎么验证（生产可证伪）

1. `kubectl describe pod` → 事件 `FailedScheduling` / 污点不匹配文案  
2. 看 Pod 落在哪台 Node、Node 标签与污点  
3. 改容忍或污点后是否按预期可调 / 被驱逐（NoExecute）  

---

## 6. 一面边界

- 不要求背全 operator 语法（`In`/`Exists`/权重数字）  
- 要求：**排斥 vs 吸引**、软硬、和混部/隔离的关系、和 request 的分工  
- 深挖 cgroup/混部压制 → 挂你的故事卡（C3），本篇点到即可  

---

## 7. 自测

1. Taint 打在谁身上？Toleration 打在谁身上？  
2. NoSchedule 和 NoExecute 差别？  
3. 为什么说「只靠 request 不够隔离干扰」？  
4. 副本打散更常用 PodAntiAffinity 还是给每个节点打不同污点？
