# G-01 超时取消的并发计数（Go）

同源：`00-diagnostic` **GO-D-10**（口述即可）；本题要求能独立写出可运行草稿。

## 题目

启动 N 个 goroutine，各自对共享计数做 `+1`（可模拟不等长工作）。总时长超过 T 后取消未完成工作，等待已退出的 goroutine，再输出最终计数。

约束提示：必须能说明「谁取消、谁同步、如何避免泄漏」。

## 验收

- 使用 `context.WithTimeout`（或等价 Deadline）传递取消
- 用 `WaitGroup`（或等价汇合）等待 goroutine 退出，无泄漏
- 共享计数用 `Mutex` 或 `atomic`，无数据竞态
- 超时后能打印当前计数；口述点到取消与同步即可，不要求完美代码

## 参考思路（先自己写再看）

1. `ctx, cancel := context.WithTimeout(...)`；`defer cancel()`
2. 每个 worker：`select` 上 `ctx.Done()` 与工作完成；收到取消则 return
3. `sync.WaitGroup`：`Add(N)` / worker 内 `Done()`；主 goroutine `Wait()`
4. 计数：`sync.Mutex` 保护 `int`，或 `atomic.AddInt64`
5. 超时后主流程仍 `Wait()`，再读计数输出

## 拓展

- 用 `errgroup.WithContext` 改写
- worker 写入 channel 汇总，主循环 `select` 超时与结果
- 人为制造泄漏（忘记 `Done` / 阻塞在 channel），用 `go test -race` 或 pprof 对照
