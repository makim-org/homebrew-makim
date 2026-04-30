#!/usr/bin/env bash

set -euo pipefail

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

OUTPUT="${TMP_DIR}/Formula/makim.rb"

bash homebrew/scripts/generate_formula.sh \
  --version "9.8.7" \
  --repo "example/makim" \
  --amd64-sha256 "$(printf 'a%.0s' {1..64})" \
  --arm64-sha256 "$(printf 'b%.0s' {1..64})" \
  --output "${OUTPUT}"

grep -Fq 'class Makim < Formula' "${OUTPUT}"
grep -Fq 'homepage "https://github.com/example/makim"' "${OUTPUT}"
grep -Fq 'version "9.8.7"' "${OUTPUT}"
grep -Fq 'url "https://github.com/example/makim/releases/download/v9.8.7/makim-darwin-amd64"' "${OUTPUT}"
grep -Fq 'url "https://github.com/example/makim/releases/download/v9.8.7/makim-darwin-arm64"' "${OUTPUT}"
grep -Fq "sha256 \"$(printf 'a%.0s' {1..64})\"" "${OUTPUT}"
grep -Fq "sha256 \"$(printf 'b%.0s' {1..64})\"" "${OUTPUT}"

echo "homebrew formula test passed"
