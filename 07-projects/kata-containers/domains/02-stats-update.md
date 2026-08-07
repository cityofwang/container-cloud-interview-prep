# 域 02：Stats / Update（节点 Agent 主线）

## 对外契约

- **读：** CRI `ContainerStats` / containerd `Task.Stats`
- **写：** containerd `Task.Update`（`crictl update`；**ctr 无 tasks update**）
- **ID：** 必须用 **业务 container id**，不是 sandbox/pause id。

## Stats 路径（待 R04 源码带读）

```text
service.go Stats → metrics.go → sandbox → kata_agent → agent rpc → Guest cgroup
```

## Update 路径（R05 半会）

```text
service.go Update → UpdateContainer → updateResources (VM) + agent updateContainer (Guest cgroup)
```

## 与 kata-monitor 关系

- **kata-monitor**：`shim-monitor.sock`，Host 侧 Prometheus 扩展。
- **containerd Stats**：Guest workload 用量（设计意图）。
- 节点 Agent **不直连 vsock**；vsock 是 shim 内部实现。

## 文档

- `docs/design/kata-2-0-metrics.md`
- `docs/design/kata-api-design.md`
- `03-observability.md`（本仓）

## 源码

见 `SOURCE-TRAIL.md` 路线 A、B。
