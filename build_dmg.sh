#!/bin/bash
set -euo pipefail

APP_NAME="MixtralWebGUI"
VOL_NAME="MixtralWebGUI"
DMG_NAME="mixtral8x7b.dmg"

rm -rf build dist
mkdir -p "build/$APP_NAME" dist

cp install.sh "build/$APP_NAME/"
cp -r webgui "build/$APP_NAME/webgui"

hdiutil create "dist/$DMG_NAME" -volname "$VOL_NAME" -srcfolder build -ov -format UDZO

echo "Created dist/$DMG_NAME"

