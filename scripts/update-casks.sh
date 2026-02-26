#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Load .env file if present (does not override existing env vars)
if [[ -f "${REPO_ROOT}/.env" ]]; then
  while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" == \#* ]] && continue
    value="${value%\"}" && value="${value#\"}"
    value="${value%\'}" && value="${value#\'}"
    if [[ -z "${!key:-}" ]]; then
      export "$key=$value"
    fi
  done < "${REPO_ROOT}/.env"
fi

GITLAB_PROJECT="clipnotify%2Fclipnotify"
GITLAB_API="https://gitlab.com/api/v4"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

if [[ -z "${GITLAB_TOKEN:-}" ]]; then
  echo "Error: GITLAB_TOKEN environment variable is required" >&2
  exit 1
fi

# Fetch latest release tag from GitLab
echo "Fetching latest release from GitLab..."
LATEST_RELEASE=$(curl -sf \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "${GITLAB_API}/projects/${GITLAB_PROJECT}/releases" \
  | jq -r '.[0].tag_name')

if [[ -z "$LATEST_RELEASE" || "$LATEST_RELEASE" == "null" ]]; then
  echo "Error: Could not fetch latest release" >&2
  exit 1
fi

echo "Latest release tag: ${LATEST_RELEASE}"

# Strip leading 'v' to get the version number
LATEST_VERSION="${LATEST_RELEASE#v}"
echo "Latest version: ${LATEST_VERSION}"

# Read current version from the native cask file
CURRENT_VERSION=$(grep -oP '^\s*version "\K[^"]+' "${REPO_ROOT}/Casks/clipnotify.rb")
echo "Current cask version: ${CURRENT_VERSION}"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
  echo "Casks are already up to date (${CURRENT_VERSION})"
  exit 0
fi

echo "New version available: ${CURRENT_VERSION} -> ${LATEST_VERSION}"

# Build download URLs using release asset link redirects
NATIVE_URL="https://gitlab.com/clipnotify/clipnotify/-/releases/${LATEST_RELEASE}/downloads/ClipNotify-native-${LATEST_RELEASE}.dmg"
CROSS_URL="https://gitlab.com/clipnotify/clipnotify/-/releases/${LATEST_RELEASE}/downloads/ClipNotify-${LATEST_RELEASE}.dmg"

if $DRY_RUN; then
  echo ""
  echo "=== Dry run ==="
  echo "Would update version: ${CURRENT_VERSION} -> ${LATEST_VERSION}"
  echo "Native DMG URL: ${NATIVE_URL}"
  echo "Cross DMG URL:  ${CROSS_URL}"
  echo "Would download DMGs and compute SHA256 hashes"
  echo "Would update Casks/clipnotify.rb and Casks/clipnotify-cross.rb"
  exit 0
fi

# Download DMGs and compute SHA256
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading native DMG..."
curl -fL \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  -o "${TMPDIR}/native.dmg" \
  "$NATIVE_URL"
NATIVE_SHA256=$(sha256sum "${TMPDIR}/native.dmg" | awk '{print $1}')
echo "Native SHA256: ${NATIVE_SHA256}"

echo "Downloading cross-platform DMG..."
curl -fL \
  --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  -o "${TMPDIR}/cross.dmg" \
  "$CROSS_URL"
CROSS_SHA256=$(sha256sum "${TMPDIR}/cross.dmg" | awk '{print $1}')
echo "Cross SHA256: ${CROSS_SHA256}"

# Update cask files
echo "Updating Casks/clipnotify.rb..."
sed -i "s/version \".*\"/version \"${LATEST_VERSION}\"/" "${REPO_ROOT}/Casks/clipnotify.rb"
sed -i "s/sha256 \".*\"/sha256 \"${NATIVE_SHA256}\"/" "${REPO_ROOT}/Casks/clipnotify.rb"

echo "Updating Casks/clipnotify-cross.rb..."
sed -i "s/version \".*\"/version \"${LATEST_VERSION}\"/" "${REPO_ROOT}/Casks/clipnotify-cross.rb"
sed -i "s/sha256 \".*\"/sha256 \"${CROSS_SHA256}\"/" "${REPO_ROOT}/Casks/clipnotify-cross.rb"

echo "Casks updated to version ${LATEST_VERSION}"
