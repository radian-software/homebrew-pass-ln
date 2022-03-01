#!/usr/bin/env bash

set -euo pipefail

ver="$(curl -sSL "https://api.github.com/repos/raxod502/pass-ln/releases/latest" | jq -r .tag_name | sed 's/^v//')"

rm -rf tmp
mkdir -p tmp
wget "https://github.com/raxod502/pass-ln/releases/download/v${ver}/pass-ln-homebrew-${ver}.tar.gz" -O tmp/pass-ln-homebrew.tar.gz

rm -rf Formula
mkdir -p Formula
tar -xf tmp/pass-ln-homebrew.tar.gz --strip-components=1 -C Formula

git add Formula
git commit -m "pass-ln ${ver}"
git show
