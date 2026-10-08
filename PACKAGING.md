# Fedora 44 and Ubuntu 26.04 packages

This is an unofficial gedit customization. Packages install under
`/opt/gedit-plus` with `/usr/bin/gedit-plus` and a distinct desktop entry.
The launcher uses `--standalone` to avoid forwarding to a running stock gedit.
Preferences and draft storage are still shared with stock gedit; avoid editing
or restoring the same draft concurrently in both versions.
The earlier per-user `gedit` launcher is retained; use `gedit-plus` explicitly
for the packaged build. Package installation does not migrate user data.

Install the unsigned package for your distribution:

    sudo dnf install ./packages/fedora-44/gedit-plus-50.0-1.fc44.x86_64.rpm
    sudo apt install ./packages/ubuntu-26.04/gedit-plus_50.0-1ubuntu26.04.1_amd64.deb

Only run the command matching your OS. Tepl 6.14 and GtkSourceView 299.6 are included privately because
Ubuntu 26.04's Tepl 6.13 and GtkSourceView 299.5 do not meet the upstream requirements.

## Rebuild

`vendor/` contains exact pinned upstream archives. The complete release source
archive includes patched gedit, libgd and Tepl, licenses and packaging scripts.
No network retrieval is required to build from that archive after dependencies
are installed. `packaging/prepare-source.sh /absolute/work-directory` prepares
that tree from a committed checkout.

For Fedora, archive it as `gedit-plus-50.0.tar.gz` in `local-rpm/SOURCES`, then:

    rpmbuild -ba --define "_topdir $PWD/local-rpm" packaging/gedit-plus.spec

For Ubuntu 26.04, prepare the tree, create an upstream orig archive excluding
`debian/`, and run `dpkg-buildpackage -us -uc` in `gedit-plus-50.0` with the
build dependencies declared in `debian/control` installed.

Builds run draft-restoration GTK tests under Xvfb plus upstream Meson checks.
Fedora RPM, source RPM, Ubuntu DEB, Debian source files, complete source archive
and SHA256 checksums accompany publication. Preserve corresponding source
alongside all redistributed binaries. macOS builds remain unverified.
