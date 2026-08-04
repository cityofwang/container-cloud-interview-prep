# 关联规则（Association Rules）

> 动态关联：**听到某类回答 → 沿维度拉 1～2 条相关线**，不展开整图。  
> 配合：`PROBE-PROTOCOL.md` 选 G2–G5 · `MINDSETS.md` §1 对比类型

## 1. 五个关联维度

| 维度 ID | 含义 | 典型关联问法 |
|---------|------|--------------|
| **layer** | 在哪一层：Host / Guest / apiserver / 数据面 / 控制面 | 「这在 Host 还是 Guest 生效？」 |
| **compare** | 与谁对比：runc/Kata、REST/gRPC、CDN/Ingress… | 「和 X 比差异在哪？」 |
| **trigger** | 触发类型：edge / level、Watch / resync / Relist / 退避 | 「是事件驱动还是周期性对账？」 |
| **ops** | 生产：排查路径、指标、限流、幂等、熔断 | 「502 第一步？风暴怎么防？」 |
| **confusable** | 易混名/易混概念 | 「这两个都叫 ingress，一样吗？」 |

**规则：** 每场 **最多激活 2 个维度**；与当前回答无关的不拉。

## 2. 触发条（回答片段 → 关联动作）

| 学员说法（触发） | 维度 | 建议生成器 | 关联方向 |
|------------------|------|------------|----------|
| 「resync 防漏 Watch」 | trigger + layer | G5 | → Relist 修缓存；resync 修 Reconcile |
| 「workqueue 够了」 | trigger | G5 | → return nil 静默成功；resync 安全网 |
| 「Handler 里 reconcile」 | trigger | G5 | → 阻塞 Watch；后移到 queue |
| 「每次 Get apiserver」 | ops + layer | G4/G5 | → Lister 读缓存；drift 才写 |
| 「Ingress 做缓存」 | confusable + compare | G5 | → CDN vs K8s Ingress |
| 「tc ingress」混 K8s Ingress | confusable | G5 | → L2 vs L7 |
| 「直连 agent vsock」 | compare + ops | G3/G4 | → containerd SDK；权限边界 |
| 「cadvisor 看容器」 | layer + compare | G5 | → Kata Guest cgroup |
| 「VM 和 pause 都在 Create」 | layer + trigger | G5 | → pause 进程在 Start |
| 「gRPC 就是 HTTP」 | compare | G3 | → HTTP/2 + Protobuf 分层 |
| 「REST 和 OpenAPI 一回事」 | compare | G3 | → 风格 vs 描述格式 |
| 「K8s API 纯 REST」 | compare | G3 | → Watch 扩展 |
| 「synthetic Update = 数据变了」 | trigger | G5 | → 人造触发 Reconcile |
| 「Leader 够了不要动作账」 | ops + compare | G5 | → 换 Leader 丢冷却 |
| 「Event UID 去重」 | ops | G5 | → 业务 dedupe key |
| 「Pod 网络 = veth 在容器里」 | layer | G2/G5 | → Host sandbox ns vs Guest eth0 |

> 上表是 **种子**；新 Chat 沉淀的误解可追加行，**不**要求覆盖所有话题。

## 3. 跨轨挂钩（可选）

| 维度值 | 可挂 |
|--------|------|
| FZ1 容器 | `KNOWLEDGE-MAP` C1/C2 |
| P 轨 kata | `07-projects/kata-containers/` |
| 故事 | `STORY-CARDS.md` S* |
| 场景 | `05-scenario-line/` |

## 4. 「关联一下」口令行为

1. 取当前话题或学员刚答的点  
2. 从 §2 找触发条；无匹配则按 **layer + compare** 各拉 1 问  
3. **先让学员答关联问**，再短讲  
4. ≤5 分钟则停，不变成大课  

## 5. 维护

- 不维护固定树状图为主索引  
- 只维护：**触发条表** + `PROBE-PROTOCOL` 生成器  
- 题源/岗位雷达变化时，检查触发条是否仍高频  
