#!/usr/bin/env bash
# 一键续聊：打印开场模板，并在 macOS 上复制到剪贴板。
# 用法：
#   bash scripts/resume-training.sh
#   bash scripts/resume-training.sh "我有空 30分钟"
#   bash scripts/resume-training.sh "周末开练"
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
today="${1:-按操盘规则继续}"

template=$(cat <<EOF
继续容器云+Go面试训练。仓库：container-cloud-interview-prep。
请严格按 CONTINUITY.md 与 docs/superpowers/specs/ 下已确认设计执行。
请先读 CONTINUITY.md（含操盘规则），再按需要读口令表与进度文件。也可用 Skill：interview-coach。
今天：${today}
EOF
)

printf '%s\n' "$template"
echo ""

copied=0
if command -v pbcopy >/dev/null 2>&1; then
  if printf '%s' "$template" | pbcopy 2>/dev/null; then
    copied=1
  fi
elif command -v xclip >/dev/null 2>&1; then
  if printf '%s' "$template" | xclip -selection clipboard 2>/dev/null; then
    copied=1
  fi
elif command -v wl-copy >/dev/null 2>&1; then
  if printf '%s' "$template" | wl-copy 2>/dev/null; then
    copied=1
  fi
fi

if [[ "$copied" -eq 1 ]]; then
  echo "已复制到剪贴板。在 Cursor 新 Chat 粘贴即可（或直接说：面试训练 / 按操盘规则继续）。"
else
  echo "未能写入剪贴板；请手动复制上方模板到 Cursor 新 Chat（或直接说：面试训练 / 按操盘规则继续）。"
fi

echo "仓库路径：$root"
