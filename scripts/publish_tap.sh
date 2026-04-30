#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="${1:?source directory is required}"
TAP_REPO="${2:?tap repo is required}"
TAP_TOKEN="${3:?tap token is required}"
PROJECT="${4:-makim}"
TAP_BRANCH="${5:-main}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

git clone \
  --branch "${TAP_BRANCH}" \
  "https://x-access-token:${TAP_TOKEN}@github.com/${TAP_REPO}.git" \
  "${TMP_DIR}/tap"

mkdir -p "${TMP_DIR}/tap/Formula"
cp "${SOURCE_DIR}/Formula/${PROJECT}.rb" "${TMP_DIR}/tap/Formula/${PROJECT}.rb"

cd "${TMP_DIR}/tap"

if git diff --quiet -- "Formula/${PROJECT}.rb"; then
  echo "Homebrew formula already up to date"
  exit 0
fi

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add "Formula/${PROJECT}.rb"
git commit -m "chore(homebrew): update ${PROJECT} formula"
git push origin "HEAD:${TAP_BRANCH}"
