# Upstream source

- Project: gedit, https://gitlab.gnome.org/World/gedit/gedit
- Base release: 50.0
- Base commit: `25d0bf0c3c40b0866fc23ec875f0af6c67f728ef`
- libgd submodule commit: `c7c7ff4e05d3fe82854219091cf116cce6b19de0`
- Local changes: `gedit-50.0-drafts.patch`

The upstream checkout and build products are intentionally ignored. The patch includes new source files and binary icon changes. Preserve upstream notices and credit when importing future versions. Before shipping a binary, archive the exact patched source tree, libgd source, and these build scripts alongside it; do not rely solely on a moving upstream URL.

Private Tepl 6.14.0 dependency: upstream commit `d60f7ded17b52ea42091c073ea81090e91f38620`, LGPL-3.0-or-later. Exact upstream source archives are stored in `vendor/`; release source archives include the patched source and libgd.

Private GtkSourceView 299.6.0 dependency: commit `a7bdc39f9fbc10c49ea7468ac1e5bf77385da0c0`, LGPL-2.1-or-later (upstream per-file notices retained).
