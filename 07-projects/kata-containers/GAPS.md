# Kata 学习缺口清单

> **已聊透（L2~L3）：** 对话 + `domains/03-memory-cgroup.md`  
> **未系统带读：** 下列项

---

## 对话已覆盖 vs 全仓 28 域

| 状态 | 域 |
|------|-----|
| **深（L2~L3）** | 5 Host cgroup、7 内存、8 CLH 部分、11 选型部分、27 架构区分、20 观测原则 |
| **半（L1~L2）** | 1 架构、2 E2E、3 Stats/Update 概念、13 VSock、18 VM 池 OOM 复用 |
| **未（需 LEARNING-8W）** | 6 Guest rustjail 源码、14 网络、15 存储、16 Nydus、17 VFIO/GPU、19 persist、21 Tracing、22 threat-model、24 Limitations 全文、18 VMCache/Templating |

---

## 按岗位优先级补缺口

| 优先级 | 缺口 | 为什么 | 怎么补 |
|--------|------|--------|--------|
| **P0** | Stats 源码带读 | 你的主线 R04 | W3 + `SOURCE-TRAIL` A |
| **P0** | Update 源码带读 | R05 半会 | W4 + 路线 B |
| **P0** | Guest cgroup 谁写 limit | Stats 数据源 | agent `container.rs` + W3 |
| **P0** | Limitations.md | 面试防 runc 思维 | W2 全文 |
| **P1** | 网络 CNI→Guest | Pod 排障 | W6 + 路线 E |
| **P1** | virtio-fs rootfs | 启动失败 | W7 + 路线 F |
| **P1** | Metrics 四层 | Prometheus | kata-2-0-metrics + shim_metrics |
| **P1** | VMCache/Templating | 启动延迟 | how-to 两篇 |
| **P1** | Sandbox persist | shim 重启 | persist/ |
| **P2** | VFIO/GPU | 场景题 | use-cases |
| **P2** | Nydus | 镜像 | kata-nydus-design |
| **P3** | runtime-rs/Dragonball | 架构面 | architecture_3.0 README |

---

## 2026-08-07 本轮新沉淀（以前文档未单独成篇）

- false 模式：**pod limit** vs **overhead cur** 组成
- **default_memory** 不会单独热插；Guest 2Gi 用途
- **CLH+KVM** GPA/HPA/EPT 模型
- **true 模式** overhead < default_memory → OOM
- **28 域** 全局地图（`KNOWLEDGE-MAP.md`）

---

## 变更日志

| 日期 | 变更 |
|------|------|
| 2026-08-07 | 全仓缺口对照 28 域 |
