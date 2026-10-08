#!/usr/bin/python3
# SPDX-License-Identifier: GPL-3.0-or-later
from pathlib import Path
import shutil
root = Path(__file__).resolve().parent
for name in (root / 'installed-paths.txt').read_text().splitlines():
    target = Path(name)
    saved = root / 'launcher-backups' / (target.parent.name + '-' + target.name)
    if target.exists() or target.is_symlink():
        target.unlink()
    if saved.exists() or saved.is_symlink():
        shutil.copy2(saved, target, follow_symlinks=False)
print('Restored original launchers. Draft data and gedit preferences were retained.')
