# 02-concurrency 题包（预置）

范围：GMP、channel/select、context、竞态与泄漏。  
**状态：** 内容已预置（查缺补漏）；**开练仍须摸底定稿并按 RESULT 解锁**（见本节原 README）。

题源：国内高频 + 题源雷达 2026-07-24。每题含对比点。

## GO-C-01 GMP 口述

**题目：** 用自己的话讲 G/M/P；本地队列空了怎么办？系统调用阻塞时大概发生什么？

**要点：** G 协程 / M 线程 / P 逻辑处理器；work stealing；syscall 时 M 与 P 可能 handoff（面试口述版即可）。  
**对比点：** 有 P 的调度 vs 早期 GM；阻塞 syscall vs 网络 poller 直觉  
**追问：** GOMAXPROCS 调的是什么？

## GO-C-02 channel 关闭与选型

**题目：** 有缓冲 vs 无缓冲？往已关闭 channel 写会怎样？什么时候你改用 Mutex？

**要点：** 无缓冲同步会合；有缓冲解耦；关闭后写 panic、读零值/false；共享状态复杂时 Mutex 更直观。  
**对比点：** channel vs Mutex；满缓冲发送 vs 泄漏（链 GO-D-06 笔记）  
**追问：** 只发送不接收，有缓冲一定会立刻堵吗？

## GO-C-03 context 取消树

**题目：** context 解决什么？值该不该塞配置？如何贯穿 HTTP/K8s client？

**要点：** 取消/超时向下传；WithCancel/Timeout；值仅请求域元数据；client 调要用同一 ctx。  
**对比点：** ctx 取消 vs 自己写 quit channel；传值 vs 全局配置  
**追问：** 子 goroutine 不听 ctx 会怎样？（链泄漏）

## GO-C-04 竞态与检查

**题目：** 数据竞态怎么发现？map 并发之外还有哪些典型坑？

**要点：** `-race`；忽略 error；复制含锁结构；slice 共享底层误用。  
**对比点：** 逻辑错 vs race detector 能抓的竞态  
**追问：** 生产能否开 race？通常不能，靠测与 code review。
