#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/coach-build.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT
unzip -q Coach-Mac-Setup.zip -d "$build_dir"
app="$build_dir/Coach-Mac-Setup/Coach.app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
xcrun swiftc -O -target arm64-apple-macos13.0 -module-cache-path /tmp/chanson-coach-module-cache CoachSource/main.swift CoachSource/MarkdownAnswer.swift CoachSource/Storage.swift -o "$app/Contents/MacOS/Coach" -framework AppKit -framework SwiftUI -framework Security -framework WebKit -framework AVFoundation -framework NaturalLanguage -framework ServiceManagement
cp CoachSource/Info.plist "$app/Contents/Info.plist"
cp CoachSource/Resources/* "$app/Contents/Resources/"
codesign --force --sign - "$app"
codesign --verify --deep --strict "$app"
# Ship the matching source alongside the app so the package remains reproducible.
rm -rf "$build_dir/Coach-Mac-Setup/CoachSource"
cp -R CoachSource "$build_dir/Coach-Mac-Setup/CoachSource"
(cd "$build_dir" && COPYFILE_DISABLE=1 zip -qr Coach-Mac-Setup.zip Coach-Mac-Setup)
mv "$build_dir/Coach-Mac-Setup.zip" Coach-Mac-Setup.zip
