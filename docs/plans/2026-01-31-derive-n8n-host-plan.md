# Derive N8N_HOST from HF_REPO Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Remove the need for `N8N_HOST` by deriving it from `HF_REPO` inside `healthcheck-rebuild.sh`, and update README examples accordingly.

**Architecture:** The script will validate `HF_REPO`, derive `owner` and `space`, and always build `space_host="${owner}-${space}.hf.space"` for health checks. README will document `HF_REPO` as the only required variable for the script.

**Tech Stack:** Bash, Markdown.

### Task 1: Update healthcheck script

**Files:**
- Modify: `healthcheck-rebuild.sh`

**Step 1: Write failing verification**

Run: `rg -n "N8N_HOST" healthcheck-rebuild.sh`
Expected: matches for the current requirement and usage.

**Step 2: Implement changes**

- Remove the required `N8N_HOST` check.
- Derive `owner` and `space` from `HF_REPO`.
- Set `N8N_HOST` (or a local `space_host`) internally before the health check.
- Update the header comments to remove `N8N_HOST` examples.

**Step 3: Re-run verification**

Run: `rg -n "N8N_HOST" healthcheck-rebuild.sh`
Expected: only internal derived usage remains, no required check or example.

**Step 4: Commit**

```
git add healthcheck-rebuild.sh
git commit -s -m "ci: derive N8N host from HF_REPO"
```

### Task 2: Update README local usage example

**Files:**
- Modify: `README.md`

**Step 1: Write failing verification**

Run: `rg -n "N8N_HOST" README.md`
Expected: match in the local healthcheck example.

**Step 2: Update README**

- Remove `N8N_HOST` from the example.
- Clarify that `HF_REPO` is sufficient for local healthcheck usage.

**Step 3: Re-run verification**

Run: `rg -n "N8N_HOST" README.md`
Expected: no matches.

**Step 4: Commit**

```
git add README.md
git commit -s -m "docs: remove N8N_HOST from healthcheck example"
```
