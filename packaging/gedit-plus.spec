%global debug_package %{nil}
Name: gedit-plus
Version: 50.0
Release: 3%{?dist}
Summary: Unofficial gedit with persistent untitled drafts
License: GPL-3.0-or-later AND LGPL-3.0-or-later
URL: https://github.com/greenfinch628/gedit-
Source0: %{name}-%{version}.tar.gz
BuildRequires: gcc, meson, ninja-build, gettext, desktop-file-utils, appstream, chrpath
BuildRequires: pkgconfig(gtk+-3.0), pkgconfig(gio-2.0), pkgconfig(libpeas-gtk-1.0), pkgconfig(gspell-1)
BuildRequires: pkgconfig(libgedit-gtksourceview-300), pkgconfig(libgedit-amtk-5), pkgconfig(libgedit-gfls-1)
BuildRequires: pkgconfig(libhandy-1), pkgconfig(icu-uc), pkgconfig(gsettings-desktop-schemas), gobject-introspection-devel
BuildRequires: xorg-x11-server-Xvfb, xorg-x11-xauth
Requires: glib2, bash, libpeas1-loader-python3
%description
Unofficial gedit 50.0 with untitled draft preservation and modified tab UI.
Installs privately under /opt/gedit-plus and uses a standalone launcher.
Preferences and drafts are shared with stock gedit. Includes private Tepl 6.14.
%prep
%autosetup
%build
packaging/build-payload.sh build
%check
packaging/build-payload.sh check
%install
packaging/build-payload.sh install %{buildroot}
find %{buildroot}/opt/gedit-plus -type f -exec chrpath -d {} \; 2>/dev/null || :
%post
/usr/bin/glib-compile-schemas /opt/gedit-plus/share/glib-2.0/schemas || :
%files
%license LICENSE LICENSES NOTICE source/COPYING vendor/tepl/LICENSES vendor/sourceview/LICENSES
%doc README.md BUILDING.md PACKAGING.md UPSTREAM.md
/opt/gedit-plus
%ghost /opt/gedit-plus/share/glib-2.0/schemas/gschemas.compiled
/usr/bin/gedit-plus
/usr/share/applications/gedit-plus.desktop
/usr/share/icons/hicolor/256x256/apps/org.gnome.gedit-drafts.png
%changelog
* Thu Oct 08 2026 Bob Czys <greenfinch628@users.noreply.github.com> - 50.0-3
- Workspace directory selector and sidebar close button.

* Thu Oct 08 2026 Bob Czys <greenfinch628@users.noreply.github.com> - 50.0-2
- Default directory browser, visible sidebar selector, and in-place folder expansion.

* Thu Oct 08 2026 Bob Czys <greenfinch628@users.noreply.github.com> - 50.0-1
- First source-complete Fedora package of the unofficial customization.
