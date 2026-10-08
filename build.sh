#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
project_root="$(cd -- "$(dirname -- "$0")" && pwd)"
source_root="$project_root/gedit"
if [ ! -d "$source_root" ]; then
  git clone --depth 1 --branch 50.0 https://gitlab.gnome.org/World/gedit/gedit.git "$source_root"
fi
expected_commit=25d0bf0c3c40b0866fc23ec875f0af6c67f728ef
if [ "$(git -C "$source_root" rev-parse HEAD)" != "$expected_commit" ]; then
  printf 'Expected the pinned gedit 50.0 source; refusing a different revision.\n' >&2
  exit 1
fi
git -C "$source_root" submodule update --init --recursive
if git -C "$source_root" apply --check "$project_root/gedit-50.0-drafts.patch" 2>/dev/null; then
  git -C "$source_root" apply "$project_root/gedit-50.0-drafts.patch"
elif git -C "$source_root" apply --reverse --check "$project_root/gedit-50.0-drafts.patch" 2>/dev/null; then
  : # Already patched.
else
  printf 'Source differs from the supplied patch; refusing to overwrite it.\n' >&2
  exit 1
fi
if [ -f "$source_root/build/meson-private/coredata.dat" ]; then
  meson setup --reconfigure "$source_root/build" "$source_root" --prefix="$project_root/install" -Dgtk_doc=false -Duser_documentation=false
else
  meson setup "$source_root/build" "$source_root" --prefix="$project_root/install" -Dgtk_doc=false -Duser_documentation=false
fi
ninja -C "$source_root/build"
ninja -C "$source_root/build" install
printf 'Built in %s. Run ./run-tests.sh, then python3 install-user.py.\n' "$project_root"
