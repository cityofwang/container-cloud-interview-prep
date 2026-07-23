# Go：interface nil 与「无 error」返回

- 维：G1｜错题：GO-D-04｜状态：半会（详解后回炉）

## 1. 一句话结论

interface 里是 **类型 + 值** 两格；只有值是 nil、类型还在时，**interface ≠ nil**。没有错误必须 **`return nil`**，不要返回「某个具体类型的 nil 指针」。

## 2. 机制要点

1. `var i interface{}` 或 `var err error`：两格都空 → `== nil` 为 true。  
2. `var p *T = nil`；`var i interface{} = p`：类型=`*T`，值=nil → **`i == nil` 为 false**。  
3. `error` 也是接口，同样规则。  
4. 坑的现场形态：函数里 `var e *MyError = nil; return e`，外层 `if err != nil` **会当成有错**。  
5. 正确「没错误」：`return nil`（字面量，接口两格都空）。

可记口诀：**nil 指针装进接口，接口就不是 nil。**

## 2.5 对比

| | 真 nil interface | typed nil 装进 interface |
|--|------------------|---------------------------|
| 两格 | 类型空 + 值空 | 类型在 + 值空 |
| `== nil` | true | **false** |
| `return` 无错误时 | `return nil` | `return (*T)(nil)` → 外层误判有错 |

和「有没有初始化」对比：面试别说成初始化问题，说成 **interface 两格是否都空**。

## 3. 代码例

```go
type MyError struct{ Msg string }

func (e *MyError) Error() string { return e.Msg }

// 错误示范：看起来像「没错误」，其实 err != nil
func bad() error {
    var e *MyError = nil
    return e // 类型=*MyError，值=nil → 外层以为失败
}

// 正确
func good() error {
    return nil
}

func maybe() error {
    if ok := check(); !ok {
        return &MyError{Msg: "boom"} // 非 nil 指针，真有错
    }
    return nil
}

func main() {
    var p *MyError = nil
    var i interface{} = p
    fmt.Println(i == nil)   // false
    fmt.Println(bad() != nil) // true ← 坑
    fmt.Println(good() != nil) // false
}
```

和 error 包装的关系：先保证「有没有错」判断正确，再用 `%w` 链表达「是哪种错」。

## 4. 追问与边界

| 追问 | 答法 |
|------|------|
| 为什么设计成这样？ | 接口要带动态类型信息，才能断言/派发方法；类型在、值空仍是「有类型的值」 |
| 怎么自查？ | 返回 error 时避免 `return typedNil`；静态检查/code review 盯 `return err` 前 err 是否具体指针类型 |
| 和 JSON/反射？ | 同类坑：空指针赋给 interface 再判断 nil |

## 5. 关联

- 摸底：GO-D-04  
- 与 GO-D-03 一起背：先 `return nil` 语义正确，再谈 `%w`

## 6. 自测（闭卷）

1. 画两格：typed nil 放进 `error` 后，`err != nil` 是什么？  
2. 「没有错误」应写 `return nil` 还是 `return (*MyError)(nil)`？为什么？
