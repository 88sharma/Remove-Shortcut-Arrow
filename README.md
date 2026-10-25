# Remove-Shortcut-Arrow
One tiny batch file that removes the shortcut-arrow overlay from desktop icons on Windows 10/11 — and restores it again if you change your mind.

# Why this script exists
Most "remove shortcut arrow" guides point Shell Icons\29 at imageres.dll,-197 or a hand-made 1×1 .ico. On many Windows builds those render as a desktop-icon glyph or an ugly black box. This script instead writes a real multi-size (16–256 px), fully transparent, PNG-based .ico and purges the icon cache — so you get a clean desktop with no arrow and no artifacts.

# Quick start
1.Download remove_shortcut_arrow.bat. 

2.Double-click it and approve the UAC prompt.

3.Explorer restarts and the arrows are gone.

Bring the arrows back:
<details> <summary><code>remove_shortcut_arrow.bat restore</code></summary>
