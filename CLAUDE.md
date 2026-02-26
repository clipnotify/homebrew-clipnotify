# ClipNotify Homebrew Tap

## What This Is

A Homebrew tap repository for distributing ClipNotify macOS apps via `brew install --cask`. Contains two casks and an automated update pipeline.

## Project Structure

- `Casks/clipnotify.rb` — Cask for the native Swift menu bar app (recommended)
- `Casks/clipnotify-cross.rb` — Cask for the Go/Wails cross-platform app
- `scripts/update-casks.sh` — Bash script that fetches latest release from GitLab, downloads DMGs, computes SHA256, and updates cask files
- `.github/workflows/update-casks.yml` — GitHub Actions workflow that runs the update script and pushes changes

## Key Details

- Source repo: `gitlab.com/clipnotify/clipnotify`
- Tap remote: `github.com/clipnotify/homebrew-clipnotify`
- Versioning: year-based (`v26.01`, `v26.02`, `v26.02.1`). Casks strip the `v` prefix.
- DMG URLs use GitLab release asset link redirects (`/-/releases/<tag>/downloads/<filename>`)
- Both casks require macOS Ventura or later
- App config lives at `~/.config/clipnotify`

## Working With Cask Files

Cask files are Ruby DSL. Key fields:
- `version` — version string without `v` prefix
- `sha256` — lowercase hex SHA256 of the DMG
- `url` — download URL, interpolates `#{version}`
- `depends_on macos:` — minimum macOS version
- `app` — name of the `.app` bundle inside the DMG
- `zap trash:` — paths to remove on `brew zap`

Reference: https://docs.brew.sh/Cask-Cookbook

## Update Script

`scripts/update-casks.sh` requires:
- `GITLAB_TOKEN` env var (project access token with `read_api` scope)
- `jq`, `curl`, `sha256sum` available in PATH
- `--dry-run` flag shows what would change without modifying files

## CI Pipeline (GitHub Actions)

The `update-casks` workflow triggers on:
- `repository_dispatch` event (from main repo's GitLab CI release job)
- Manual trigger (`workflow_dispatch`)
- Daily schedule

Requires GitHub secret: `GITLAB_TOKEN` (GitLab read API for fetching releases).

## Conventions

- Keep cask files minimal — follow Homebrew cask conventions, no unnecessary stanzas
- The update script handles both casks atomically (same version for both)
- Commit messages for automated updates follow the format: `Update casks to <version>`
