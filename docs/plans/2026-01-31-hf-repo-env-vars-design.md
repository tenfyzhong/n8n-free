# HF_REPO-Based Space Remote Design

## Summary

Replace the hardcoded Hugging Face Space remote in workflows and `healthcheck-rebuild.sh`
with a configurable environment variable: `HF_REPO` (format `owner/space`). This keeps
the deploy workflow portable across forks while retaining the existing behavior.

## Goals

- Remove hardcoded `tenfyzhong/n8n-free` in workflows and scripts.
- Use `HF_REPO` as the single source of truth for Space path.
- Fail fast with clear errors when `HF_REPO` or `HF_TOKEN` is missing or malformed.
- Keep behavior otherwise identical (no change to triggers or update logic).

## Non-Goals

- Deriving `HF_REPO` from `HF_SPACE_URL` in every workflow.
- Changing healthcheck logic or schedules.
- Introducing new secrets beyond `HF_REPO` and `HF_TOKEN`.

## Design

Workflows that push to the Space (`push-to-huggingface.yml` and `update-n8n.yml`)
will read `HF_REPO` from GitHub Actions variables and build the Space remote URL
as `https://<owner>:${HF_TOKEN}@huggingface.co/spaces/${HF_REPO}`. The `<owner>`
segment is derived by splitting `HF_REPO` at `/`, ensuring the same value is used
for both the auth user and the path. Each workflow will validate `HF_REPO` before
attempting to push, emitting a clear `::error::` message and exiting if it is not
set or not in `owner/space` format.

`healthcheck-rebuild.sh` will keep its existing flow but will use the same
`HF_REPO`-derived remote URL instead of a hardcoded Space. The script will add
explicit checks for `HF_REPO` and `HF_TOKEN` early to fail fast with a readable
error message, and it will validate the `owner/space` format before pushing.

The README will be updated to mark `HF_REPO` as required and document the expected
format so users configure the repo once without editing workflow files.

## Rollout

1. Update workflows and `healthcheck-rebuild.sh` to use `HF_REPO`.
2. Update README with required variables.
3. Validate by searching for the old hardcoded value.
