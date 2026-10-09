#!/bin/bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
dest=$(realpath -m "$1")
mkdir -p "$dest/gedit-plus-50.0/source" "$dest/gedit-plus-50.0/vendor"
git -C "$root" archive HEAD -- . ':!packages' | tar -xf - -C "$dest/gedit-plus-50.0"
cp -a "$dest/gedit-plus-50.0/packaging/debian" "$dest/gedit-plus-50.0/debian"
tar -xzf "$root/vendor/gedit-50.0.tar.gz" --strip-components=1 -C "$dest/gedit-plus-50.0/source"
mkdir -p "$dest/gedit-plus-50.0/source/subprojects/libgd"
tar -xzf "$root/vendor/libgd-c7c7ff4.tar.gz" --strip-components=1 -C "$dest/gedit-plus-50.0/source/subprojects/libgd"
git -C "$dest/gedit-plus-50.0/source" apply "$root/gedit-50.0-drafts.patch"
tar -xzf "$root/vendor/tepl-6.14.0.tar.gz" -C "$dest/gedit-plus-50.0/vendor"
tar -xzf "$root/vendor/sourceview-299.6.0.tar.gz" -C "$dest/gedit-plus-50.0/vendor"
printf 'Source prepared at %s\n' "$dest/gedit-plus-50.0"
