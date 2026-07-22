#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
missing=0
require() {
  if [[ ! -e "$root/$1" ]]; then
    echo "MISSING: $1"
    missing=1
  else
    echo "OK: $1"
  fi
}
require "README.md"
require "00-profile/PROFILE.md"
require "00-profile/STORY-CARDS.md"
require "00-profile/ANSWERING.md"
require "00-profile/ASSESSMENT.md"
require "01-round1/QUESTIONS.md"
require "01-round1/CHECKLIST.md"
require "02-round2/README.md"
require "03-round3/README.md"
require "04-round4/README.md"
require "05-coding-line/README.md"
require "05-coding-line/01-shell-pod-events.md"
require "mocks/TEMPLATE.md"
require "review/wrong-book.md"
require "review/job-market/README.md"
require "06-golang/00-diagnostic/QUESTIONS.md"
require "06-golang/00-diagnostic/CHECKLIST.md"
require "06-golang/00-diagnostic/RESULT.md"
require "06-golang/01-basics/README.md"
require "06-golang/02-concurrency/README.md"
require "06-golang/03-cloudnative/README.md"
require "06-golang/04-backend-lite/README.md"
require "06-golang/05-coding/README.md"
require "06-golang/05-coding/G-01-timeout-counter.md"
require "06-golang/mocks/TEMPLATE.md"
if [[ "$missing" -ne 0 ]]; then
  echo "Structure check FAILED"
  exit 1
fi
echo "Structure check PASSED"
