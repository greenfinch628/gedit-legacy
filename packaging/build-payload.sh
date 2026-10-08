#!/bin/bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
prefix=/opt/gedit-plus
case ${1:-build} in
build)
  meson setup build-sourceview vendor/sourceview --prefix="$prefix" --libdir=lib -Dgtk_doc=false -Dtests=false
  meson compile -C build-sourceview
  DESTDIR="$root/stage-deps" meson install -C build-sourceview --no-rebuild
  mkdir -p build-pc
  for pc in stage-deps/opt/gedit-plus/lib/pkgconfig/*.pc; do
    sed "s|^prefix=.*|prefix=$root/stage-deps/opt/gedit-plus|" "$pc" > "build-pc/$(basename "$pc")"
  done
  export PKG_CONFIG_PATH="$root/build-pc${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  export GI_TYPELIB_PATH="$root/stage-deps/opt/gedit-plus/lib/girepository-1.0${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
  export LD_LIBRARY_PATH="$root/stage-deps/opt/gedit-plus/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  meson setup build-tepl vendor/tepl --prefix="$prefix" --libdir=lib -Dgtk_doc=false -Dtests=false
  meson compile -C build-tepl
  DESTDIR="$root/stage-deps" meson install -C build-tepl --no-rebuild
  mkdir -p build-pc
  for pc in stage-deps/opt/gedit-plus/lib/pkgconfig/*.pc; do
    sed "s|^prefix=.*|prefix=$root/stage-deps/opt/gedit-plus|" "$pc" > "build-pc/$(basename "$pc")"
  done
  export PKG_CONFIG_PATH="$root/build-pc${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  export GI_TYPELIB_PATH="$root/stage-deps/opt/gedit-plus/lib/girepository-1.0${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
  export LD_LIBRARY_PATH="$root/stage-deps/opt/gedit-plus/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  meson setup build-gedit source --prefix="$prefix" --libdir=lib -Dgtk_doc=false -Duser_documentation=false
  meson compile -C build-gedit
  ;;
check)
  glib-compile-schemas build-gedit/data
  export GSETTINGS_SCHEMA_DIR="$root/build-gedit/data"
  export LD_LIBRARY_PATH="$root/stage-deps/opt/gedit-plus/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  export GI_TYPELIB_PATH="$root/stage-deps/opt/gedit-plus/lib/girepository-1.0${GI_TYPELIB_PATH:+:$GI_TYPELIB_PATH}"
  export GSETTINGS_BACKEND=memory GDK_BACKEND=x11 GTK_A11Y=none
  test_root=$(mktemp -d)
  export XDG_DATA_HOME="$test_root"
  for mode in seed restore failure save-discard after-cleanup; do xvfb-run -a build-gedit/gedit/test-drafts "$mode"; done
  export XDG_DATA_HOME="$test_root/active" DRAFT_TEST_ACTIVE=1
  for mode in seed-draft-active restore; do xvfb-run -a build-gedit/gedit/test-drafts "$mode"; done
  unset DRAFT_TEST_ACTIVE
  export XDG_DATA_HOME="$test_root/toggle"
  for mode in toggle toggle-after-discard; do xvfb-run -a build-gedit/gedit/test-drafts "$mode"; done
  meson test -C build-gedit --print-errorlogs
  ;;
install)
  dest=$(realpath "$2")
  DESTDIR="$dest" meson install -C build-sourceview --no-rebuild
  DESTDIR="$dest" meson install -C build-tepl --no-rebuild
  DESTDIR="$dest" meson install -C build-gedit --no-rebuild
  install -Dm755 packaging/gedit-plus "$dest/usr/bin/gedit-plus"
  install -Dm644 packaging/gedit-plus.desktop "$dest/usr/share/applications/gedit-plus.desktop"
  install -Dm644 source/data/icons/org.gnome.gedit-256x256.png "$dest/usr/share/icons/hicolor/256x256/apps/org.gnome.gedit-drafts.png"
  find "$dest/opt/gedit-plus" -name gschemas.compiled -o -name icon-theme.cache -o -name mimeinfo.cache | xargs -r rm -f
  ;;
esac
