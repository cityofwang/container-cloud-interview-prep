# 01-basics 题包（第一批）

摸底后开练。作答四段式 + 对比点。优先顺序：B-01 → B-02 → B-03 → …

## GO-B-01 error 包装与 Is/As（主缺口）

**题目：** 中间层怎么返回 error？`%w` 和 `%v` 对比？何时 `errors.Is` / `As`？

**要点：** `(T,error)`；`%w` 保链；边界打日志；sentinel 勿滥用。  
**对比点：** `%w` vs `%v`；Is vs As  
**链：** GO-D-03；笔记 `notes/A-target/go-error-wrapping.md`

## GO-B-02 interface nil 与 return nil

**题目：** typed nil 放进 error 为何 `err != nil`？正确无错误怎么返回？

**要点：** 类型+值两格；`return nil`。  
**对比点：** 真 nil vs typed nil  
**链：** GO-D-04；笔记 `go-interface-nil.md`

## GO-B-03 slice append 与底层数组

**题目：** 函数内 append 后调用方不一定看见新元素，为什么？子切片泄内存？

**要点：** 头拷贝 ptr/len/cap；append 可能换数组；要 return 新 slice。  
**对比点：** 共享底层 vs 扩容换数组  
**链：** GO-D-01

## GO-B-04 defer 顺序与命名返回值

**题目：** 多个 defer 顺序？和命名返回值交互怎么记？

**要点：** LIFO；defer 在 return 前；改命名返回值点到即可。  
**对比点：** defer 顺序 vs 书写顺序  
**链：** GO-D-05

## GO-B-05 map 并发（巩固）

**题目：** 多 goroutine 读写同一 map？为何有时选 Mutex 不选 channel？

**要点：** 非并发安全；Mutex 或 sync.Map；随机写用锁。  
**对比点：** channel 流水线 vs Mutex 共享状态  
**链：** GO-D-02（会，抽查）
