#!/usr/bin/python3
# SPDX-License-Identifier: GPL-3.0-or-later
"""Install launchers for the tested build, retaining existing files for rollback."""
from pathlib import Path
import shutil
import os
import subprocess
root = Path(__file__).resolve().parent
home = Path.home()
launcher = home / '.local/bin/gedit'
desktop = home / '.local/share/applications/org.gnome.gedit.desktop'
service = home / '.local/share/dbus-1/services/org.gnome.gedit.service'
icon_root = root / 'install/share/icons/hicolor'
icon_sources = sorted(icon_root.glob('*/apps/org.gnome.gedit-drafts.png'))
icon_targets = [home / '.local/share/icons/hicolor' / p.relative_to(icon_root) for p in icon_sources]
paths = (launcher, desktop, service, *icon_targets)
previously_installed = (root / 'installed-paths.txt').exists()
backup = root / 'launcher-backups'
backup.mkdir(exist_ok=True)
for target in paths:
    target.parent.mkdir(parents=True, exist_ok=True)
    saved = backup / (target.parent.name + '-' + target.name)
    if not previously_installed and not saved.exists() and (target.exists() or target.is_symlink()):
        shutil.copy2(target, saved, follow_symlinks=False)
binary = root / 'install/bin/gedit'
# A quoted absolute path keeps the launch independent of shell working directories.
launcher.write_text('#!/bin/sh\nexec "' + str(binary) + '" "$@"\n')
launcher.chmod(0o755)
for source, target in zip(icon_sources, icon_targets):
    shutil.copy2(source, target)
text = (root / 'install/share/applications/org.gnome.gedit.desktop').read_text()
lines = []
main_group = False
for line in text.splitlines():
    if line.startswith("["):
        main_group = line == "[Desktop Entry]"
    if main_group and line.startswith("Name["):
        continue
    if main_group and line.startswith("Name="):
        line = "Name=gedit+"
    if line.startswith('Exec='):
        line = line.replace(str(binary), str(launcher))
        if line.startswith('Exec=gedit'):
            line = 'Exec=' + str(launcher) + line[len('Exec=gedit'):]
    if line.startswith('DBusActivatable='):
        line = 'DBusActivatable=false'
    lines.append(line)
desktop.write_text('\n'.join(lines) + '\n')
service.write_text('[D-BUS Service]\nName=org.gnome.gedit\nExec=' + str(launcher) + ' --gapplication-service\n')
cache_tool = shutil.which('gtk4-update-icon-cache') or shutil.which('gtk-update-icon-cache')
if cache_tool:
    subprocess.run([cache_tool, '-f', '-t', str(home / '.local/share/icons/hicolor')], check=True)
desktop_tool = shutil.which('update-desktop-database')
if desktop_tool:
    subprocess.run([desktop_tool, str(desktop.parent)], check=True)
(root / 'installed-paths.txt').write_text('\n'.join(str(p) for p in paths) + '\n')
print('Installed per-user gedit launcher, desktop entry, D-Bus service, and icons.')
