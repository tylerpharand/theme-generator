#!/bin/bash

BUILD_DIR="./tmp"
CONTROL_TEMPLATE="./templates/control.template"
INFO_PLIST="./src/Info.plist"

# Load config
source "./config"

# Export icons as PNG
rm -r './src/icons' && mkdir './src/icons'
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
# TODO: Generate icon masks of varying dimensions (?)
mkdir "$THEME_DIR/Bundles" && mkdir "$THEME_DIR/Bundles/com.apple.mobileicons.framework"
cp -r "./src/icons/" "$THEME_DIR/IconBundles"
cp -r "./src/Bundles" "$THEME_DIR/"
eval "echo \"$(< $INFO_PLIST)\"" > "$THEME_DIR/Info.plist"

dpkg -b $WORK_DIR
cp "$WORK_DIR.deb" "./build/${THEME_NAME}_$VERSION.deb"

# Complete
echo "Saved package to "./build/moonlight_v0.1.0""

# Copy theme to device
echo "Copying theme to device..."
scp -i ~/.ssh/id_rsa_iphone -rq $THEME_DIR root@tyleriphone.local:/Library/Themes/

# Restart springboard
echo "killall backboardd" | ssh root@tyleriphone.local -i ~/.ssh/id_rsa_iphone

# Tidy up
rm -r $BUILD_DIR

# TODO: Add test cases? CI Pipeline?
echo "✨ Done!"
