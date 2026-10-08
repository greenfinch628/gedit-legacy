# gedit+ packages

Release 50.0, package revision 1, source commit 61ca9de.
Packages are locally unsigned, built on Fedora 44 x86_64 and Ubuntu 26.04
amd64 respectively. Use only the package matching your distribution:

    sudo dnf install ./packages/fedora-44/gedit-plus-50.0-1.fc44.x86_64.rpm
    sudo apt install ./packages/ubuntu-26.04/gedit-plus_50.0-1ubuntu26.04.1_amd64.deb

Launch with `gedit-plus`. Packages install under /opt/gedit-plus and provide a
separate desktop entry, using standalone mode. Preferences and draft storage
are still shared with stock gedit. The existing per-user `gedit` launcher is
not replaced by these packages. See ../PACKAGING.md for details.

Private Tepl 6.14 and GtkSourceView 299.6 are included to meet gedit 50.0's
requirements without upgrading system libraries. Exact patched gedit, libgd,
Tepl and GtkSourceView source, original notices, license texts and build
scripts are included in the complete source archive and source RPM.
The .dsc, .debian.tar.xz and .orig.tar.gz rebuild the Ubuntu package.
Retain equivalent access to these sources whenever redistributing binaries.

Validation passed:

- All nine draft-restoration scenarios on Fedora and Ubuntu.
- Six configured Meson checks on Fedora; two on Ubuntu.
- Fedora RPM digest check and installation transaction dry run.
- Extracted Fedora RPM launcher smoke test in an isolated mount namespace.
- Ubuntu DEB installation and launcher smoke test in a disposable container.

Ubuntu GUI tests use GTK's sandboxed image loaders. When building inside
rootless Podman on SELinux hosts, nested bubblewrap can require a disposable
container with `--network none --cap-add SYS_ADMIN --security-opt seccomp=unconfined
--security-opt label=disable`, mounting only the build workspace. These are
build-container options, not application or host security settings.

Verify the release files:

    cd packages
    sha256sum -c SHA256SUMS
