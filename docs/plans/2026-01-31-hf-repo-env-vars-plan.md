# HF_REPO Remote Configuration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace hardcoded Hugging Face Space remotes with `HF_REPO`-driven configuration in workflows and `healthcheck-rebuild.sh`, and update README accordingly.

**Architecture:** Use `HF_REPO` (`owner/space`) to construct the Space git remote in workflows and scripts. Validate presence and format before pushing. Keep existing behavior otherwise unchanged.

**Tech Stack:** Bash, GitHub Actions YAML, Markdown.

### Task 1: Update GitHub Actions workflows to use HF_REPO

**Files:**
- Modify: `.github/workflows/push-to-huggingface.yml`
- Modify: `.github/workflows/update-n8n.yml`

**Step 1: Write failing verification**

Run: `rg -n "tenfyzhong/n8n-free" .github/workflows`
Expected: matches in both workflow files.

**Step 2: Update push-to-huggingface workflow**

- Add `HF_REPO: ${{ vars.HF_REPO }}` to env.
- In the push step, validate `HF_REPO` and format (`owner/space`).
- Derive `owner` from `HF_REPO` and build the remote URL.

**Step 3: Update update-n8n workflow**

- Add `HF_REPO: ${{ vars.HF_REPO }}` to env.
- In the push step, validate `HF_REPO` and format.
- Derive `owner` and build the remote URL.

**Step 4: Re-run verification**

Run: `rg -n "tenfyzhong/n8n-free" .github/workflows`
Expected: no matches (exit code 1).

**Step 5: Commit**

```
git add .github/workflows/push-to-huggingface.yml .github/workflows/update-n8n.yml
git commit -s -m "ci: use HF_REPO for Space remote"
```

### Task 2: Update healthcheck script and README

**Files:**
- Modify: `healthcheck-rebuild.sh`
- Modify: `README.md`

**Step 1: Write failing verification**

Run: `rg -n "tenfyzhong/n8n-free" healthcheck-rebuild.sh README.md`
Expected: match in `healthcheck-rebuild.sh` (and possibly README).

**Step 2: Update healthcheck-rebuild.sh**

- Validate `HF_REPO` and `HF_TOKEN` early with clear errors.
- Validate `HF_REPO` format (`owner/space`) and derive `owner`.
- Replace the hardcoded Space remote with `HF_REPO`.

**Step 3: Update README**

- Mark `HF_REPO` as required in GitHub Actions variables.
- Remove the instruction to edit workflow/script remotes manually.
- Note that `HF_REPO` is used to build the Space remote URL.

**Step 4: Re-run verification**

Run: `rg -n "tenfyzhong/n8n-free" healthcheck-rebuild.sh README.md`
Expected: no matches (exit code 1).

**Step 5: Commit**

```
git add healthcheck-rebuild.sh README.md
git commit -s -m "docs: require HF_REPO for Space remote"
```
