# L3 Roadmap + Knowledge Map + Notes Implementation Plan

> **For agentic workers:** Use task checkboxes; keep changes aligned with `docs/superpowers/specs/2026-07-23-l3-roadmap-and-notes-design.md`.

**Goal:** Land L3 roadmap, knowledge-map index, notes skeleton, and first three detailed notes from known Go gaps.

**Architecture:** Markdown-only training artifacts under `00-profile/`, `review/roadmap/`, and `notes/`; wire into README/CONTINUITY and structure check. No new runtime code.

**Tech Stack:** Markdown; existing bash `scripts/check-structure.sh`.

## Global Constraints

- A+B scope only; no L4/Offer detailed plans
- Notes grow from wrong-book gaps; no encyclopedia dump
- Do not change L3 score thresholds without `按雷达校准评估`
- New “dimension ideas” stay observational until学员确认

---

### Task 1: Skeleton index + L3 plan

**Files:**
- Create: `00-profile/KNOWLEDGE-MAP.md`
- Create: `review/roadmap/README.md`
- Create: `review/roadmap/L3-plan.md`
- Create: `notes/README.md`

- [x] Write knowledge map with A domains + B thin booklet and status from current checklist/wrong-book
- [x] Write L3-plan with P0–P3, ETA window 2026-09-22～2026-11-12, next command
- [x] Write notes README (structure + growth rules)

### Task 2: First three A-domain notes

**Files:**
- Create: `notes/A-target/go-error-wrapping.md`
- Create: `notes/A-target/go-interface-nil.md`
- Create: `notes/A-target/go-goroutine-leak.md`

- [x] Detailed notes per spec §5.2; link GO-D-03/04/06

### Task 3: Wire progress surfaces

**Files:**
- Modify: `README.md`
- Modify: `CONTINUITY.md`
- Modify: `scripts/check-structure.sh`
- Modify: `00-profile/ASSESSMENT.md` (optional O* 观察维建议，不进加权)

- [x] Add paths/commands; require new core files in structure check
- [x] Update CONTINUITY snapshot (P0 + notes landed)

### Task 4: Verify

- [x] Run `bash scripts/check-structure.sh` → PASSED
