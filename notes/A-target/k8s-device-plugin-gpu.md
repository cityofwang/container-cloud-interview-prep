# Device Plugin / GPU 调度（现象级）

- 维：C1｜题：R1-Q22｜JD：GPU/vGPU/训推平台高频
- 深度：一面现象级即可；不要求写过 Device Plugin 代码

> 总句：**GPU 不是普通 CPU/内存，靠 Device Plugin 向 kubelet 报「可调度资源」；调度用扩展资源 + 常配合污点/亲和把卡机和业务分开。**

---

## 1. 链路

```text
节点上 GPU 驱动 / 厂商插件
    ↓
Device Plugin（gRPC 注册到 kubelet）
    ↓
节点 Capacity/Allocatable 出现如 nvidia.com/gpu: N
    ↓
Pod requests/limits 写扩展资源
    ↓
调度器匹配有卡的节点 → kubelet 分配设备到容器
```

---

## 2. 对比 / 和已有知识挂钩

| 点 | 怎么说 |
|----|--------|
| 和普通资源 | CPU/内存内建；GPU 是 **扩展资源**，插件上报 |
| 和污点/亲和 | 卡机常 taint + toleration / nodeAffinity，避免普通业务占满 |
| 和混部 | 你的混部故事可对比「加速器资源更稀缺、隔离更硬」 |
| 和 Kata | 少数场景 GPU 直通/虚拟化更复杂；无经历别编 |

---

## 3. 面试边界（诚实）

- 没写过插件：可以说「生产用过 GPU 节点池 / 看过 allocatable」，原理按上图。  
- 深挖 CUDA/MIG/vGPU：承认边界，落到「资源怎么暴露给调度」。

## 4. 30 秒背板

> Device Plugin 把设备挂进 kubelet 资源模型；Pod 用扩展资源申请；调度到有卡节点。运维侧常配合污点池和监控，防止 GPU 节点被普通负载打满。
