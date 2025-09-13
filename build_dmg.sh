#!/bin/bash
set -euo pipefail

VOL_NAME="MixtralWebGUI"
DMG_NAME="mixtral8x7b.dmg"
TMPDIR=$(mktemp -d)
STAGING="$TMPDIR/staging"
DIST_DIR="dist"

# Ensure required macOS tools exist
command -v hdiutil >/dev/null 2>&1 || { echo "hdiutil not found; run on macOS" >&2; exit 1; }
command -v osascript >/dev/null 2>&1 || { echo "osascript not found; run on macOS" >&2; exit 1; }

mkdir -p "$STAGING/.background" "$DIST_DIR" assets

# Generate background image
python3 create_dmg_background.py assets/background.png
cp assets/background.png "$STAGING/.background/background.png"

# Copy installer and assets
cp install.sh "$STAGING/install.command"
cp README.txt "$STAGING/README.txt"
cp -R webgui "$STAGING/webgui"

chmod 755 "$STAGING/install.command"

# Hide webgui folder if possible
if command -v chflags >/dev/null 2>&1; then
  chflags hidden "$STAGING/webgui"
fi

# Create Applications alias
ln -s /Applications "$STAGING/Applications"

# Create temporary DMG
hdiutil create "$TMPDIR/tmp.dmg" -ov -volname "$VOL_NAME" -srcfolder "$STAGING" -format UDRW

# Mount DMG
MOUNTPOINT="/Volumes/$VOL_NAME"
hdiutil attach "$TMPDIR/tmp.dmg" -mountpoint "$MOUNTPOINT" -readwrite -noverify -noautoopen

# Apply Finder styling
osascript <<EOF || true
tell application "Finder"
  tell disk "$VOL_NAME"
    open
    set current view of container window to icon view
    set toolbar visible of container window to false
    set statusbar visible of container window to false
    set bounds of container window to {400, 200, 1000, 650}
    set viewOptions to icon view options of container window
    set arrangement of viewOptions to not arranged
    set icon size of viewOptions to 80
    set background picture of viewOptions to file ".background:background.png"
    set position of item "install.command" to {160, 200}
    set position of item "Applications" to {440, 200}
    set position of item "README.txt" to {300, 350}
    update without registering applications
    delay 3
  end tell
end tell
EOF

# Finalize DMG
sync
hdiutil detach "$MOUNTPOINT"
hdiutil convert "$TMPDIR/tmp.dmg" -format UDZO -o "$DIST_DIR/$DMG_NAME"
rm -rf "$TMPDIR"

echo "Created $DIST_DIR/$DMG_NAME"
