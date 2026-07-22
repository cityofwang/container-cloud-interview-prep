# Go 摸底题包

作答用四段式（见 `00-profile/ANSWERING.md`）。先自评再闭卷对练。

## GO-D-01 slice 与底层数组
**题目：** 函数里对 slice append 后，调用方不一定看见新元素，为什么？  
**参考答法要点：** slice 含 ptr/len/cap；传的是头拷贝；append 可能换底层数组；要回传或传指针。  
**追问：** 子切片导致内存泄而不放？  
**挂钩提示：** 无强挂钩则讲清即可  
**题源标签：** 国内高频

## GO-D-02 map 并发
**题目：** 多 goroutine 读写同一 map 会怎样？怎么改？  
**参考答法要点：** 非并发安全，可能 fatal；sync.Mutex 或 sync.Map；少用全局 map。  
**追问：** sync.Map 适合什么读写比？  
**题源标签：** 国内高频

## GO-D-03 error
**题目：** 你怎么做 error 返回？什么时候包装？  
**参考答法要点：** 多返回值；fmt.Errorf %w；errors.Is/As；勿丢弃 error；日志在边界打。  
**追问：** sentinel error 滥用问题？  
**题源标签：** 国内高频

## GO-D-04 interface nil
**题目：** 一个变量是 interface 类型，内部动态值是 nil 指针，和 == nil 比较可能怎样？  
**参考答法要点：** interface 含类型+值；仅值 nil 但类型非 nil 时 interface != nil；返回 error 时常见坑。  
**追问：** 如何正确返回「无 error」？  
**题源标签：** 国内高频

## GO-D-05 defer
**题目：** 多个 defer 顺序？和命名返回值交互你怎么记？  
**参考答法要点：** LIFO；defer 在 return 前；改命名返回值的经典题点到即可。  
**追问：** defer 里再 panic？  
**题源标签：** 国内高频

## GO-D-06 goroutine 泄漏
**题目：** 线上 goroutine 泄漏常见原因？怎么发现？  
**参考答法要点：** 未退出的 for/select、channel 永久阻塞、忘了 context 取消；pprof goroutine；监控数量。  
**追问：** 和内存涨如何区分？  
**挂钩提示：** 事件处置 worker 若卡住会堆积  
**题源标签：** 国内高频

## GO-D-07 channel
**题目：** 有缓冲 vs 无缓冲？什么场景你不用 channel？  
**参考答法要点：** 无缓冲同步会合；有缓冲解耦；关闭与 range；选 Mutex 共享状态有时更简单。  
**追问：** 往已关闭 channel 写？  
**题源标签：** 国内高频

## GO-D-08 context
**题目：** context 解决什么？传值该不该用？  
**参考答法要点：** 取消/超时/截止向下传递；WithCancel/Timeout/Deadline；值仅请求域元数据；别当全局配置。  
**追问：** 如何贯穿 HTTP/K8s client 调用？  
**题源标签：** 国内高频

## GO-D-09 K8s 事件自动处置
**题目：** 若用 Go 消费 K8s Warning 事件做自动重启/扩容类动作，如何避免事件风暴打崩集群？  
**参考答法要点：** 限流/冷却/去重/只处理可行动 Reason；幂等；熔断人工确认；与 controller 调谐区分。  
**追问：** List-Watch 断线重连？  
**挂钩提示：** S3 事件驱动经历  
**题源标签：** 结合学员经历

## GO-D-10 编码：超时取消的并发计数
**题目：** N 个 goroutine 并发 +1 共享计数；总时长超过 T 后取消未完成工作并输出计数。口述思路，能写 Go 更好。  
**参考答法要点：** context.WithTimeout；WaitGroup；Mutex 或 atomic；select ctx.Done；退出避免泄漏。  
**验收：** 点到取消与同步；不要求完美代码。  
**题源标签：** 国内高频
