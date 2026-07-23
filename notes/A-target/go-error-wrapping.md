# Go：error 包装与 errors.Is / As

- 维：G1｜错题：GO-D-03｜状态：不会（详解后回炉）

## 1. 一句话结论

中间层用 **`fmt.Errorf("...: %w", err)`** 保留错误链；边界用 **`errors.Is` / `errors.As`** 做分支或打日志；**不要**只用 `%v` 拼字符串冒充包装。

## 2. 机制要点

1. Go 惯用多返回值 `(T, error)`，调用方先看 `err != nil`。
2. error 是接口；包装后要能「认出原来是哪种错」→ 需要链，不是纯文案。
3. **`%w`**：把底层 err 挂进新 error，链还在。  
   **`%v`/`%s`**：只把文字抄进去，**身份丢了**，`Is`/`As` 找不到原错。
4. **`errors.Is(err, target)`**：沿链找是否等于某个 sentinel（或实现了 `Is` 的值）。
5. **`errors.As(err, &ptr)`**：沿链找能否当成某个具体类型，取出字段。
6. 日志尽量在**边界**（HTTP/CLI/worker 出口）打；中间层优先 `%w` 上抛，避免同一错打三遍。

## 3. 代码例

```go
var ErrNotFound = errors.New("not found")

func loadPod(ns, name string) error {
    err := clientGet(ns, name) // 假设返回 ErrNotFound
    if err != nil {
        // 推荐：带上下文 + 保留链
        return fmt.Errorf("load pod %s/%s: %w", ns, name, err)
    }
    return nil
}

func handle(err error) {
    if errors.Is(err, ErrNotFound) {
        // 404 / 跳过 / 告警降级
        return
    }
    var pe *os.PathError
    if errors.As(err, &pe) {
        log.Printf("path=%s op=%s", pe.Path, pe.Op)
        return
    }
    log.Printf("unexpected: %v", err)
}
```

你以前常用：

```go
return fmt.Errorf("scale failed: %v", err) // 人能看懂，程序认不出原错
```

面试怎么说：

> 展示给人对 `%v` 也行，但作为包装我用 `%w`，这样上层 `errors.Is` 还能判断超时、NotFound、Conflict。

## 4. 追问与边界

| 追问 | 答法 |
|------|------|
| sentinel 滥用？ | 到处 `errors.New("not found")` 新字面量 → `Is` 对不上；应包级 `var ErrX = errors.New(...)` 或自定义类型 |
| 和字符串 `Contains`？ | 脆弱、改文案就挂；优先 `Is`/`As` |
| 带什么上下文？ | 可行动字段：ns、name、操作；别塞密钥、整段响应体 |
| 自定义错误？ | `type MyError struct{...}` + `Error() string`；需要时实现 `Unwrap() error` 或 `Is` |

## 5. 关联

- 摸底：GO-D-03  
- 下一节：`06-golang/01-basics`  
- 挂钩：K8s client 区分超时 / NotFound / Conflict 时靠链，不靠抠英文句子

## 6. 自测（闭卷）

1. `%w` 和 `%v` 对 `errors.Is` 各有什么影响？  
2. 中间层该不该每层 `log.Printf` 再 return？你怎么选？
