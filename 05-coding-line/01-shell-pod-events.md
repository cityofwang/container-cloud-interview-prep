# C-01 统计 Pod 事件类型次数（Shell）

## 题目

给定多行文本（模拟 `kubectl get events` 精简输出），每行格式：

```text
TYPE    REASON      OBJECT
Warning Failed      pod/foo
Normal  Scheduled   pod/bar
Warning BackOff     pod/foo
```

用 Shell（bash + 常见命令）统计每种 `REASON` 出现次数，按次数降序输出。

## 验收

- 对示例输入输出含 `Failed`/`Scheduled`/`BackOff` 的计数
- 能口头说明用了哪些命令、为何不用复杂框架

## 参考思路（先自己写再看）

`awk`/`cut` + `sort` + `uniq -c` + `sort -nr`

## 拓展

改成只统计 `Warning` 行；或输出 JSON 行（可用 Python）。
