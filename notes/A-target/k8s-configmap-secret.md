# ConfigMap / Secret（机制 + 安全边界）

- 维：C1｜题：R1-Q05｜状态：一面不会→补洞中

> 面试一句话：两者都是**把配置投进 Pod**；Secret 面向敏感数据，但 **base64 ≠ 加密**。

---

## 1. 结论背板

| | ConfigMap | Secret |
|--|-----------|--------|
| 用途 | 非敏感配置（环境、开关、配置文件） | 密码、Token、证书、密钥 |
| 常见投递 | env / volume 挂载 | 同上 |
| 编码 | 明文存在对象里 | 对象字段是 **base64 编码**（可轻易解码） |
| 默认安全 | 靠 RBAC | 仍靠 RBAC + 少暴露；生产常开 etcd 静态加密 / 外置 KMS |

**选型：** 普通配置 → ConfigMap；一旦泄漏会造成账号/集群风险 → Secret（或更好：外置密钥系统）。

---

## 2. 机制（你没用过也可以这样理解）

集群里存一份「配置对象」，Pod 创建时 kubelet **注入**进去：

```text
ConfigMap/Secret（etcd）
        │
        ├─ 环境变量 envFrom / valueFrom
        └─ 卷挂载 volume（文件出现在容器路径）
```

- **env**：改 ConfigMap/Secret **通常不自动更新**已跑着的 Pod 环境变量（要重建 Pod 才吃到新值，视实现/版本而定；面试说「多数要滚动/重建」够用）。
- **volume 挂载**：很多场景下文件可被 kubelet 刷新（仍建议当「最终可能要滚动」处理）。

和「写死在镜像里」对比：配置外置 → 同一镜像多环境；密钥不进镜像 → 少泄漏面。

---

## 3. 对比（必会）

| 对比点 | 怎么说 |
|--------|--------|
| CM vs Secret | 敏感度；Secret 有额外类型（Opaque、tls、dockerconfigjson 等） |
| base64 vs 加密 | `echo xxx \| base64 -d` 就能还原 → **不是加密** |
| etcd | 默认可近明文存；生产要 **encryption at rest** / 供应商托管加密 |
| 权限 | RBAC：谁能 get secret；ServiceAccount 别乱挂 |
| 进镜像/日志 | 最常见事故：Dockerfile ENV、应用把密码打日志、CI 明文 |

---

## 4. 安全注意（口述清单）

1. **当敏感数据用 Secret，别当 ConfigMap**  
2. **别把密钥打进镜像 / 代码仓库**  
3. **RBAC 收紧**：限制 get/list secret  
4. **少挂载、少环境变量**（env 易被 `docker inspect`/调试看到）  
5. **轮转**：泄漏后换密钥 + 滚动工作负载  
6. **生产加码**：etcd 静态加密、云 KMS、密封密钥（Sealed Secrets）等  

---

## 5. 追问：打进镜像或日志了怎么办？

1. **发现**：镜像扫描 / 历史层；日志检索；仓库 secret 扫描  
2. **止血**：立刻**轮转**密钥（旧密钥当已泄漏）；限制访问  
3. **清传播面**：重建不含密钥的镜像；清日志/制品权限；查是否已外泄  
4. **防再发**：CI 扫描、禁止明文、改用 Secret/KMS  

---

## 6. 自测

1. 为什么说 Secret 的 base64 不是加密？  
2. 对比：配置热更新更常指望 volume 还是 env？为何？  
3. 误把 DB 密码打进镜像，前三步做什么？
