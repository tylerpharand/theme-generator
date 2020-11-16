#!/bin/bash

BUILD_DIR="./tmp"
CONTROL_TEMPLATE="./templates/control.template"
INFO_PLIST_TEMPLATE="./templates/Info.plist.template"

# Load config
source "./config"

# Export icons as PNG
echo "🎨 Exporting icons..."
osascript ./scripts/export-artboards.scpt

# Build theme
echo "🔨 Building theme (${THEME_NAME})..."
if [ -d "$BUILD_DIR" ]; then rm -Rf $BUILD_DIR; fi

WORK_DIR="$BUILD_DIR/$THEME_NAME"
mkdir $BUILD_DIR
mkdir $WORK_DIR
mkdir "$WORK_DIR/DEBIAN"
eval "echo \"$(< $CONTROL_TEMPLATE)\"" > "$WORK_DIR/DEBIAN/control"

mkdir "$WORK_DIR/Library"
mkdir "$WORK_DIR/Library/Themes"
THEME_DIR="$WORK_DIR/Library/Themes/${THEME_NAME}.theme"
mkdir $THEME_DIR
mkdir "$THEME_DIR/IconBundles"
mkdir "$THEME_DIR/Bundles"
# TODO: Generate icon masks of varying dimensions (?)
mkdir "$THEME_DIR/Bundles/com.apple.mobileicons.framework"
cp -r "./src/icons/" "$THEME_DIR/IconBundles"
eval "echo \"$(< $INFO_PLIST_TEMPLATE)\"" > "$THEME_DIR/Info.plist"

dpkg -b $WORK_DIR
cp "$WORK_DIR.deb" "./build/${THEME_NAME}_$VERSION.deb"

# Complete
echo "Saved package to "./build/moonlight_v0.1.0""

# Copy theme to device
echo "Copying theme to device..."
scp -rq $THEME_DIR root@10.0.0.5:/Library/Themes/

# Tidy up
rm -r $BUILD_DIR

# TODO: Add test cases? CI Pipeline?
echo "✨ Done!"
