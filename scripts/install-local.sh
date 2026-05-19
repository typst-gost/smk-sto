#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
version="$(head -n 1 "$root/VERSION" | tr -d '\r\n')"
if [[ -z "$version" ]]; then
  echo "VERSION file is empty." >&2
  exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  dest="$HOME/Library/Caches/typst/packages/preview/smk-sto/$version"
else
  dest="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/preview/smk-sto/$version"
fi

rm -rf "$dest"
mkdir -p "$dest"

tar \
  --exclude=".git" \
  --exclude=".github" \
  --exclude="temp-render" \
  --exclude="reference" \
  --exclude=".claude" \
  --exclude="scripts" \
  --exclude="standard-lab.pdf" \
  --exclude="standard-practice.pdf" \
  --exclude="standard-common.pdf" \
  --exclude="AGENTS.md" \
  --exclude=".gitignore" \
  --exclude="template/lab-example.typ" \
  --exclude="template/practice-example.typ" \
  --exclude="template/practice-main.typ" \
  -C "$root" -cf - . | tar -C "$dest" -xf -

echo "Installed smk-sto $version to $dest"
