# Building and validation

The current build was exercised on Fedora 44 with gedit 50.0. Required tools include Git, GCC, Meson, Ninja, pkg-config, Python 3, and gettext. Fedora development dependencies include:

```sh
sudo dnf install gtk3-devel glib2-devel gobject-introspection-devel libgedit-tepl-devel libpeas1-devel gspell-devel gsettings-desktop-schemas-devel libpeas1-loader-python3
```

Their dependencies include libgedit-gtksourceview, libgedit-amtk, libgedit-gfls, libhandy, and enchant development files. Meson reports missing or incompatible versions. Documentation generation is disabled in the development build. Tests additionally need `xvfb-run` (Fedora package `xorg-x11-server-Xvfb`) and desktop-file/AppStream validation tools used by upstream Meson checks.

`./build.sh` retrieves pinned upstream source and libgd, applies the supplied patch, and installs into this project's `install/` directory. It never installs system-wide. `./run-tests.sh` uses isolated data directories and an in-memory settings backend; it does not change personal preferences or drafts.

The GTK test harness covers mixed named/untitled tabs, multiple windows, canceled closing, restoration across separate processes, cursor and active-tab restoration, failed draft writes, saving a restored draft as a named file, explicit discard, and the preservation preference. Restart testing demonstrates durable restoration; a physical reboot is a separate manual acceptance check.

Before release, also exercise the actual desktop launcher and everyday editing. Debian dependencies and supported distribution versions must be verified on the intended Debian/Ubuntu build machines. macOS requires a separate build and native Quit/restoration tests.
