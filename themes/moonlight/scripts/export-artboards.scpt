set f to POSIX file "/Users/tyler/Desktop/theme-generator/themes/moonlight/src/moonlight.ai"
tell application "Adobe Illustrator"
	activate
	open f without dialogs
	do javascript of file "/Users/tyler/Desktop/theme-generator/themes/moonlight/scripts/export-artboards.jsx"
end tell
