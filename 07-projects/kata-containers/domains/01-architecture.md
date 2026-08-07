# 域 01：整体架构

## 生产路径

```text
kubelet → containerd (CRI) → containerd-shim-kata-v2 (Go)
  → virtcontainers → cloud-hypervisor (KVM)
  → kata-agent (Guest, Rust, ttRPC/vsock)
```

## 关键结论

- **1 Pod ≈ 1 VM ≈ 1 shim**；Pod 内多容器 **共享同一 VM**。
- **Kata 3.0.0** 默认 **Go runtime**；`architecture_3.0/` 描述 **runtime-rs + Dragonball**，非现网默认栈。
- shim 返回 **PID = CLH**，不是 Guest 业务 pid。

## 面试 30s

Kata 在 containerd 下仍是 shim v2，但 workload 跑在轻量 VM 里；节点 Agent 对外应走 **CRI/containerd Task API**，读 **Guest 容器 cgroup**。

## 文档

- `docs/design/architecture/README.md`
- `docs/design/end-to-end-flow.md`
- `docs/hypervisors.md`
