# Remove HF_SPACE_URL Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Remove all usage of `HF_SPACE_URL` and derive the Space host and URL solely from `HF_REPO`.

**Architecture:** Replace any workflow references to `HF_SPACE_URL` with `HF_REPO`-derived values. `HF_REPO` is the single source of truth for both the Space host (`<owner>-<space>.hf.space`) and Space page URL.

**Tech Stack:** GitHub Actions YAML, Bash, Markdown.

### Task 1: Replace HF_SPACE_URL in workflows

**Files:**
- Modify: `.github/workflows/healthcheck.yml`
- Modify: `.github/workflows/huggingface-keep-alive.yml`

**Step 1: Write failing verification**

Run: `rg -n "HF_SPACE_URL" .github/workflows`
Expected: matches in `healthcheck.yml` and `huggingface-keep-alive.yml`.

**Step 2: Update healthcheck workflow**

- Remove `HF_SPACE_URL` env var usage.
- Require `HF_REPO` and validate `owner/space` format.
- Derive `space_host="${owner}-${space}.hf.space"` for `N8N_HOST`.
- Pass `HF_REPO` and `N8N_HOST` to `healthcheck-rebuild.sh`.

**Step 3: Update keep-alive workflow**

- Replace `curl "${{ vars.HF_SPACE_URL }}"` with a derived URL from `HF_REPO`.
- Add validation for `HF_REPO` and format in the run step.

**Step 4: Re-run verification**

Run: `rg -n "HF_SPACE_URL" .github/workflows`
Expected: no matches (exit code 1).

**Step 5: Commit**

```
git add .github/workflows/healthcheck.yml .github/workflows/huggingface-keep-alive.yml
git commit -s -m "ci: derive Space URL from HF_REPO"
```

### Task 2: Update README to remove HF_SPACE_URL

**Files:**
- Modify: `README.md`

**Step 1: Write failing verification**

Run: `rg -n "HF_SPACE_URL" README.md`
Expected: matches in the Actions variables section and troubleshooting.

**Step 2: Update README**

- Remove `HF_SPACE_URL` from the Actions variables table.
- Update text to describe `HF_REPO` as the single required value.
- Update troubleshooting guidance to reference `HF_REPO` instead.

**Step 3: Re-run verification**

Run: `rg -n "HF_SPACE_URL" README.md`
Expected: no matches (exit code 1).

**Step 4: Commit**

```
git add README.md
git commit -s -m "docs: remove HF_SPACE_URL references"
```
