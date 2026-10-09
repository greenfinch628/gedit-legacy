#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
task_root="$(cd -- "$(dirname -- "$0")" && pwd)"
test_root="$(mktemp -d "$task_root/test-run-XXXXXX")"
export GSETTINGS_BACKEND=memory GDK_BACKEND=x11
export XDG_DATA_HOME="$test_root"
for mode in seed restore failure save-discard after-cleanup; do
  xvfb-run -a "$task_root/gedit/build/gedit/test-drafts" "$mode" > "$test_root/$mode.log" 2>&1
  cat "$test_root/$mode.log"
done
export XDG_DATA_HOME="$test_root/active-draft"
mkdir -p "$XDG_DATA_HOME"
export DRAFT_TEST_ACTIVE=1
for mode in seed-draft-active restore; do
  xvfb-run -a "$task_root/gedit/build/gedit/test-drafts" "$mode" > "$test_root/active-$mode.log" 2>&1
  cat "$test_root/active-$mode.log"
done
export XDG_DATA_HOME="$test_root/toggle"
mkdir -p "$XDG_DATA_HOME"
unset DRAFT_TEST_ACTIVE
for mode in toggle toggle-after-discard; do
  xvfb-run -a "$task_root/gedit/build/gedit/test-drafts" "$mode" > "$test_root/$mode.log" 2>&1
  cat "$test_root/$mode.log"
done
export XDG_DATA_HOME="$test_root/workspace"
mkdir -p "$XDG_DATA_HOME"
xvfb-run -a "$task_root/gedit/build/gedit/test-drafts" workspace > "$test_root/workspace.log" 2>&1
cat "$test_root/workspace.log"
export XDG_DATA_HOME="$test_root/columns"
mkdir -p "$XDG_DATA_HOME"
xvfb-run -a "$task_root/gedit/build/gedit/test-columns" > "$test_root/columns.log" 2>&1
cat "$test_root/columns.log"
meson test -C "$task_root/gedit/build" --print-errorlogs
printf 'Test artifacts: %s\n' "$test_root"
