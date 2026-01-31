# README Refresh Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rewrite README.md to provide clear Hugging Face Spaces deployment steps, precise secrets/variables setup, and accurate operations guidance aligned with current workflows and scripts.

**Architecture:** Documentation-only change. Update README.md content to match existing GitHub Actions workflows, Space configuration requirements, and the healthcheck script behavior.

**Tech Stack:** Markdown, GitHub Actions, Hugging Face Spaces, Supabase.

## Design Summary

The README will be task-oriented and concise: a brief overview, a quick start checklist, a step-by-step deployment guide for Hugging Face Spaces, a clear secrets/variables table, and an operations section covering update workflows and keep-alive/healthcheck automation. It will include troubleshooting for common misconfigurations (missing HF_SPACE_URL, SSL mismatches, webhook/base URL mismatches), and it will fix typos and tighten phrasing.

### Task 1: Rewrite README content and structure

**Files:**
- Modify: `README.md`

**Step 1: Write a failing verification for the new section**

Run: `rg -n "Quick start" README.md`
Expected: no matches (exit code 1) because the new section is not present yet.

**Step 2: Update README.md content**

- Add a short overview and a Quick start checklist.
- Rewrite the deployment steps to be Hugging Face Spaces only.
- Align secrets/variables with current workflows:
  - Hugging Face Space secrets/variables (DB and n8n runtime).
  - GitHub Actions secrets/variables (HF_TOKEN, HF_SPACE_URL, SUPABASE_URL/KEY, optional TG settings).
- Document update automation (update-n8n.yml and push-to-huggingface.yml) and keep-alive workflows.
- Document healthcheck-rebuild.sh usage and its required environment variables.
- Fix typos and tighten phrasing.

**Step 3: Re-run verification**

Run: `rg -n "Quick start" README.md`
Expected: at least one match with line numbers.

Run: `rg -n "HF_SPACE_URL|SUPABASE_URL|SUPABASE_KEY|HF_TOKEN" README.md`
Expected: matches for all required secrets/variables.

**Step 4: Commit**

Run:
```
git add README.md
git commit -s -m "docs: refresh README for HF Spaces deployment"
```
Expected: commit created with sign-off.
