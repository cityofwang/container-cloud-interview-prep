# Kata 源码带读路线

> 源码根：`~/wangfanDoc/GoDemo/src/kata-containers`  
> 每条路线：**入口 → 关键函数 → 设计文档**

---

## 路线 A：Stats 全链（R04，P0）

```text
containerd TaskService.Stats
  → pkg/containerd-shim-v2/service.go          Stats()
  → pkg/containerd-shim-v2/metrics.go          gatherMetrics / 序列化
  → virtcontainers/sandbox.go                  Stats() / sandbox 级
  → virtcontainers/container.go                container 级
  → virtcontainers/kata_agent.go               statsContainer() ttRPC
  → src/agent/src/rpc.rs                       StatsContainer
  → src/agent/rustjail/                        Guest cgroup 读用量
```

**文档：** `docs/design/kata-2-0-metrics.md`、`docs/design/architecture/README.md`（Guest cgroup 监控）

**探测题：** 用 **业务 container id**，不是 sandbox/pause id。

---

## 路线 B：Update 全链（R05，P0）

```text
containerd TaskService.Update
  → pkg/containerd-shim-v2/service.go          Update()
  → virtcontainers/sandbox.go                  UpdateContainer()
  → virtcontainers/sandbox.go                  updateResources()  ← VM 热插
  → virtcontainers/clh.go                      ResizeMemory / ResizeVCPUs
  → virtcontainers/kata_agent.go               updateContainer() ttRPC
  → src/agent/src/rpc.rs                       UpdateContainer
  → src/agent/rustjail/src/container.rs        set(LinuxResources)
```

**文档：** `docs/design/host-cgroups.md`、`docs/design/kata-api-design.md`

**注意：** `ctr` 无 `tasks update`；用 `crictl update` 或 containerd Go SDK。

---

## 路线 C：CreateSandbox / 起 VM（R01–R02，P0）

```text
pkg/containerd-shim-v2/create.go             Create (PodSandbox)
  → pkg/katautils/create.go                    CreateSandbox
  → virtcontainers/api.go                      CreateSandbox → startVM
  → virtcontainers/sandbox.go                  createResourceController / setupResourceController
  → virtcontainers/clh.go                      CreateVM (Memory=default_memory)
  → virtcontainers/kata_agent.go               createSandbox (Go) vs gRPC CreateSandboxRequest
```

**文档：** `docs/design/end-to-end-flow.md`

---

## 路线 D：Host cgroup（R07，P0）

```text
virtcontainers/sandbox.go                    createResourceController()
  → pkg/resourcecontrol/cgroups.go             RenameCgroupPath kata_
  → virtcontainers/sandbox.go                  setupResourceController()  shim 进 overhead 或 kata_*
  → virtcontainers/sandbox.go                  resourceControllerUpdate() vCPU AddThread
```

**文档：** `docs/design/host-cgroups.md`

---

## 路线 E：网络（R06，P1）

```text
virtcontainers/sandbox.go                    createNetwork()
  → virtcontainers/network*.go
  → virtcontainers/*_endpoint.go               veth / macvlan / physical / tap
```

**文档：** `docs/design/architecture/networking.md`

---

## 路线 F：存储 / rootfs（P1）

```text
virtcontainers/fs_share*.go
virtcontainers/mount.go
virtcontainers/clh.go                        virtio-fs 配置
```

**文档：** `docs/design/architecture/storage.md`、`docs/how-to/how-to-use-virtio-fs-with-kata.md`

---

## Top 10 锚点文件（岗位优先）

1. `pkg/containerd-shim-v2/service.go`
2. `pkg/containerd-shim-v2/metrics.go`
3. `virtcontainers/sandbox.go`
4. `virtcontainers/kata_agent.go`
5. `virtcontainers/clh.go`
6. `pkg/oci/utils.go`
7. `docs/design/host-cgroups.md`
8. `docs/design/kata-2-0-metrics.md`
9. `docs/Limitations.md`
10. `src/agent/src/rpc.rs`
