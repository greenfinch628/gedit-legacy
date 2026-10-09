# Built-in rectangular selection

Rectangular selection is built into gedit+. It works in the Fedora and Ubuntu builds without installing or enabling a plugin.

## Select, copy, and cut

1. Hold **Alt** and drag with the **left mouse button** from one corner of the text block to the opposite corner. You can drag in either direction.
2. Release the mouse button and Alt. Press **Ctrl+C** to copy or **Ctrl+X** to cut, or right-click the rectangle and choose **Copy** or **Cut**.
3. Use **Ctrl+Z** to undo the whole cut in one step. Press **Esc** or click normally to clear a rectangle without changing the text.

Pressing a modifier key such as Ctrl alone does not clear the selection. Copy remains available in a read-only document; Cut and Paste require an editable document. The rectangle's context menu enables Paste when the clipboard contains text.

## Blank lines and short lines

A rectangle covers the same column range on every selected document line. Copy produces one clipboard row for each line, including empty rows for blank lines. Cut removes only the text in that column range and preserves every line break, including leading, consecutive, and trailing blank lines. A short line contributes only the text it contains; it is not padded or extended.

For example, selecting the first three columns of these four lines:

```text
abcONE

123TWO
xy
```

copies `abc`, an empty row, `123`, and `xy`, separated by newlines. Cutting leaves:

```text
ONE

TWO

```

## Tabs, display, and paste

Tabs inside the copied rectangle become spaces according to the configured tab width. Cutting through part of a tab preserves its unselected portion as spaces. Columns count Unicode characters, with tabs expanded to tab stops. Use a monospace font and unwrapped lines to make the rectangle easiest to see.

Pasting uses ordinary text paste. It does not insert clipboard rows into a column of existing lines.

## Desktop shortcuts

Use **Alt+drag** on Fedora and Ubuntu. If your desktop is configured to move windows with Alt+drag, change that desktop shortcut to **Super/Windows+drag** so gedit+ receives the mouse gesture.
