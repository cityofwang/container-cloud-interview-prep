# Go：goroutine 泄漏

- 维：G2｜错题：GO-D-06｜状态：半会（详解后回炉）

## 1. 一句话结论

泄漏 = goroutine **该退出却退不出**。常见三类：**channel/select 永久堵**、**循环不听 context**、**阻塞 IO 无超时**。用 **协程数**发现，用 **pprof goroutine** 定位。

## 2. 机制要点

1. 每个 `go func` 都要有明确生命周期（做完 return / 听取消 / 超时）。  
2. **无缓冲 channel**：发送与接收必须碰面；少一边就挂死。  
3. **有缓冲 channel**：缓冲没满时发送成功；**满了还发且无人收** → 同样永久阻塞（只是晚一点）。  
4. `select` 若只有一个永远不来的 case、又无 `ctx.Done()` → 泄漏。  
5. 发现：`runtime.NumGoroutine()` / 监控指标持续爬升；CPU 不一定高。  
6. 定位：pprof 的 goroutine 剖面，看大量卡在 `chan receive` / `select` 等。  
7. 和内存涨区分：先看协程数；协程平稳、堆猛涨 → 更像缓存/slice 未释放。

## 2.5 对比

| | 无缓冲 channel | 有缓冲 channel |
|--|----------------|----------------|
| 发送何时可能堵 | 立刻要接收方碰面 | 缓冲**满了**之后仍发送 |
| 会不会泄漏 | 会 | **也会**（只是晚一点） |

| | goroutine 泄漏 | 内存涨 |
|--|----------------|--------|
| 主信号 | 协程数持续爬升 | heap 涨、协程可平稳 |
| 先做 | pprof goroutine | pprof heap / 查缓存 |

| | 死锁感 | 泄漏感 |
|--|--------|--------|
| 常见 | 多方互相等 | 数量涨、单方退不出（可重叠） |

## 3. 代码例

### 3.1 只发不收（有缓冲也会漏）

```go
func leakBuffered() {
    ch := make(chan int, 1)
    ch <- 1 // OK
    go func() {
        ch <- 2 // 缓冲满，无人收 → 泄漏
    }()
}
```

### 3.2 用 context 退出

```go
func worker(ctx context.Context, in <-chan Event) {
    for {
        select {
        case <-ctx.Done():
            return
        case ev, ok := <-in:
            if !ok {
                return
            }
            handle(ev)
        }
    }
}
```

### 3.3 事件风暴场景（挂钩你的经历）

```go
// 危险：每个 Warning 都 go 一次，且不取消
func onWarning(ev Event) {
    go func() {
        for {
            act(ev) // 无 ctx、无退出 → 风暴时协程堆积
            time.Sleep(time.Second)
        }
    }()
}
```

面试挂钩：自动处置要 **限流/去重/冷却**，且 worker 必须可取消，否则泄漏 + 打集群。

### 3.4 简易观察

```go
log.Println("goroutines:", runtime.NumGoroutine())
```

## 4. 追问与边界

| 追问 | 答法 |
|------|------|
| 有缓冲就不会漏？ | 会；满了照样堵 |
| 和死锁区别？ | 死锁常是多方互相等；泄漏强调「数量涨、退不出」。表现可重叠 |
| 忘了 `wg.Done`？ | Wait 方永久等，也是退不出；和泄漏一起答 |
| 怎么防？ | 传 ctx；谁发谁关 channel（约定清晰）；超时/deadline；限制并发数 |

## 5. 关联

- 摸底：GO-D-06  
- 下一题：GO-D-07 channel、GO-D-08 context（机制互补）  
- 生产：事件处置 worker、informer/回调里随意 `go`

## 6. 自测（闭卷）

1. 举一个「有缓冲仍然泄漏」的发送场景。  
2. 协程数涨、CPU 不高，你先做哪两步排查？
