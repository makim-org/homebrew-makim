#!/usr/bin/env bash

set -euo pipefail

VERSION=""
REPO="makim-org/makim"
PROJECT="makim"
DESC="A tool that helps organize and simplify helper commands using YAML configuration"
LICENSE="BSD-3-Clause"
AMD64_SHA256=""
ARM64_SHA256=""
OUTPUT="homebrew/Formula/${PROJECT}.rb"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
      ;;
    --repo)
      REPO="$2"
      shift 2
      ;;
    --project)
      PROJECT="$2"
      shift 2
      ;;
    --desc)
      DESC="$2"
      shift 2
      ;;
    --license)
      LICENSE="$2"
      shift 2
      ;;
    --amd64-sha256)
      AMD64_SHA256="$2"
      shift 2
      ;;
    --arm64-sha256)
      ARM64_SHA256="$2"
      shift 2
      ;;
    --output)
      OUTPUT="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${VERSION}" || -z "${AMD64_SHA256}" || -z "${ARM64_SHA256}" ]]; then
  echo "Usage: $0 --version <version> --amd64-sha256 <sha> --arm64-sha256 <sha> [--repo <owner/repo>] [--project <name>] [--desc <desc>] [--license <license>] [--output <path>]" >&2
  exit 1
fi

# Capitalize project name for the class
CLASS_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${PROJECT:0:1})${PROJECT:1}"

mkdir -p "$(dirname "${OUTPUT}")"

cat > "${OUTPUT}" <<EOF
class ${CLASS_NAME} < Formula
  desc "${DESC}"
  homepage "https://github.com/${REPO}"
  version "${VERSION}"
  license "${LICENSE}"

  on_macos do
    on_arm do
      url "https://github.com/${REPO}/releases/download/v#{VERSION}/${PROJECT}-darwin-arm64"
      sha256 "${ARM64_SHA256}"
    end

    on_intel do
      url "https://github.com/${REPO}/releases/download/v#{VERSION}/${PROJECT}-darwin-amd64"
      sha256 "${AMD64_SHA256}"
    end
  end

  def install
    bin.install Dir["${PROJECT}-darwin-*"].first => "${PROJECT}"
  end

  test do
    output = shell_output("#{bin}/${PROJECT} --version")
    assert_match "Version: #{VERSION}", output
  end
end
EOF
