# Repository Guidelines

This repository is a template for running n8n on Hugging Face Spaces with a Supabase backend and GitHub Actions automation. Keep contributions small, automation-focused, and well documented.

## Project Structure & Module Organization

- `Dockerfile` pins the n8n image version used by the Space.
- `.github/workflows/` contains automation for updates, keep-alive pings, healthchecks, and pushing to Hugging Face.
- `healthcheck-rebuild.sh` is a local script that triggers a rebuild when health checks fail.
- `rebuild.txt` is touched to force rebuilds.
- `Auto keep n8n alive and updates on n8n-free repo.json` is the importable n8n workflow.
- `README.md` is the primary setup and configuration guide.

## Build, Test, and Development Commands

- `HF_REPO=owner/space N8N_HOST=space.hf.space bash healthcheck-rebuild.sh`
  Runs the readiness check and rebuilds if unhealthy. Optional: `TG_TOKEN`, `TG_CHAT_ID` for Telegram alerts.
- GitHub Actions are the main execution path. Use workflow dispatch in `.github/workflows/update-n8n.yml` to update the pinned n8n version.

## Coding Style & Naming Conventions

- No trailing whitespace.
- YAML/JSON: 2-space indentation.
- Shell scripts: keep `bash` shebangs and 4-space indentation in blocks.
- Name workflow files with clear kebab-case (e.g., `update-n8n.yml`).

## Testing Guidelines

- No unit-test framework is configured.
- Validate changes via GitHub Actions healthcheck workflows and manual runs of `healthcheck-rebuild.sh`.
- If you add tests, document the framework and commands in `README.md` and wire them into CI.

## Commit & Pull Request Guidelines

- Commit message conventions seen in history: `chore: Update n8n to version X` and `Revert "chore: Update n8n to version X"`.
- All commits must be signed off: `git commit -s`.
- PRs should describe workflow/Dockerfile changes, include linked issues if any, and update `README.md` when behavior or setup changes.

## Security & Configuration Tips

- Never commit secrets. Use GitHub Actions secrets/variables and Hugging Face Space settings.
- Common secrets: `HF_TOKEN`, `SUPABASE_URL`, `SUPABASE_KEY`, database credentials.

## Agent-Specific Notes

- If you use git worktrees, create them under `.git/wtm_data/`.
