# Go 摸底结果

完成 `QUESTIONS.md` + `CHECKLIST.md` 后填写。本结果驱动下一节开题包。

## 自评统计

| 档位 | 数量 | 题号 |
|------|------|------|
| 会 | | |
| 半会 | | |
| 不会 | | |

合计应 = 10。

## 建议先学小节

勾选一项（可依错题分布微调）：

- [ ] **01-basics** — 半会/不会集中在 GO-D-01…05（slice / map / error / interface / defer）
- [ ] **02-concurrency** — 半会/不会集中在 GO-D-06…08、GO-D-10（泄漏 / channel / context / 编码）
- [ ] **两者** — 两侧均有明显缺口；先 basics 再 concurrency，或按错题交替

GO-D-09（云原生事件）偏 `03-cloudnative`；摸底后若仅此项弱，可先开 basics/concurrency，再记入云原生优先级。

## 应入库错题 id

（半会 + 不会；对练答错也写入）

```
-
```

## G1 / G2 初评

对照 `00-profile/ASSESSMENT.md`（1–5，先粗评）：

| 维 | 名称 | 初评 | 依据（题号） |
|----|------|------|--------------|
| G1 | Go 语言基础 | n/a | GO-D-01…05 |
| G2 | Go 并发 | n/a | GO-D-06…08、GO-D-10 |

初评后回写 `ASSESSMENT.md` 对应行。

## 下一步口令建议

按结果选一句对教练说：

1. 「摸底完成，RESULT 建议先开 **01-basics**，请解锁题包。」
2. 「摸底完成，RESULT 建议先开 **02-concurrency**，请解锁题包。」
3. 「摸底完成，RESULT 建议 **两者**；请先解锁 basics，再 concurrency。」
4. 「错题已入库：`GO-D-…`；请按错题本节奏复习后再开下一节。」
