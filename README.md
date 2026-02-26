# Homebrew Tap for ClipNotify

Homebrew tap for installing [ClipNotify](https://gitlab.com/clipnotify/clipnotify) on macOS — a bridge between remote Claude Code sessions and your local Mac.

## Installation

```bash
brew tap clipnotify/homebrew https://github.com/clipnotify/homebrew-clipnotify.git
brew install --cask clipnotify
```

### Available Casks

| Cask | Description | Install |
|------|-------------|---------|
| `clipnotify` | Native Swift menu bar app (recommended) | `brew install --cask clipnotify` |
| `clipnotify-cross` | Go/Wails cross-platform app | `brew install --cask clipnotify-cross` |

Both casks require **macOS Ventura (13.0)** or later.

## Updating

```bash
brew upgrade --cask clipnotify
```

## Uninstalling

```bash
brew uninstall --cask clipnotify
brew untap clipnotify/homebrew
```

The `zap` stanza removes `~/.config/clipnotify` on full cleanup (`brew zap`).

## How This Tap Works

This repository is a [Homebrew tap](https://docs.brew.sh/Taps) hosted on GitHub. Cask definitions live in `Casks/` and are automatically updated when new releases are published to the main ClipNotify repository on GitLab.

### Automated Updates

When a new ClipNotify release is tagged:

1. The main repo's GitLab CI triggers a GitHub Actions workflow via `repository_dispatch`
2. `scripts/update-casks.sh` fetches the latest release tag from the GitLab API
3. Both DMGs are downloaded and their SHA256 checksums computed
4. The cask files are updated with the new version and checksums
5. Changes are committed and pushed to `main`

Updates can also be triggered manually from the GitHub Actions UI or on a daily schedule.

### Repository Structure

```
.
├── Casks/
│   ├── clipnotify.rb          # Native Swift app cask
│   └── clipnotify-cross.rb    # Go/Wails cross-platform app cask
├── scripts/
│   └── update-casks.sh        # Release scanner + cask updater
├── .github/workflows/
│   └── update-casks.yml       # GitHub Actions workflow for automated updates
└── README.md
```

## Development

### Running the Update Script Locally

The update script requires a GitLab personal access token with `read_api` scope:

```bash
export GITLAB_TOKEN="glpat-..."
bash scripts/update-casks.sh --dry-run    # Preview changes
bash scripts/update-casks.sh              # Apply changes
```

### Validating Cask Syntax

```bash
brew tap --force clipnotify/homebrew .
brew audit --cask clipnotify
brew audit --cask clipnotify-cross
```

### GitHub Actions Secrets

The workflow requires this repository secret:

| Secret | Purpose |
|--------|---------|
| `GITLAB_TOKEN` | GitLab project access token with `read_api` scope, used to fetch releases and download DMGs |

The workflow uses the built-in `GITHUB_TOKEN` for pushing commits, so no additional push token is needed.

### Triggering from the Main Repo

Add this to the main `clipnotify/clipnotify` GitLab CI release job to trigger a tap update after assets are uploaded:

```bash
curl -X POST \
  --fail \
  -H "Authorization: token ${GITHUB_PAT}" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/clipnotify/homebrew-clipnotify/dispatches" \
  -d '{"event_type": "new-release"}'
```

This requires a GitHub personal access token stored as `GITHUB_PAT` in the GitLab CI variables.

## Versioning

ClipNotify uses year-based versioning: `v26.01`, `v26.02`, `v26.02.1`, etc. The cask `version` field strips the `v` prefix (e.g., `26.02.1`), and the download URL interpolates it back as `v#{version}`.

## Links

- [ClipNotify source](https://gitlab.com/clipnotify/clipnotify)
- [ClipNotify releases](https://gitlab.com/clipnotify/clipnotify/-/releases)
- [Homebrew cask documentation](https://docs.brew.sh/Cask-Cookbook)
