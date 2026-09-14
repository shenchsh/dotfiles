#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/coach-build.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT
unzip -q Coach-Mac-Setup.zip -d "$build_dir"
mkdir -p "$build_dir/Coach-Mac-Setup/Coach.app/Contents/MacOS" "$build_dir/Coach-Mac-Setup/Coach.app/Contents/Resources"
xcrun swiftc -O -target arm64-apple-macos13.0 -module-cache-path /tmp/chanson-coach-module-cache CoachSource/main.swift CoachSource/MarkdownAnswer.swift CoachSource/SharedSettings.swift -o "$build_dir/Coach-Mac-Setup/Coach.app/Contents/MacOS/Coach" -framework AppKit -framework SwiftUI -framework Security -framework WebKit -framework AVFoundation -framework NaturalLanguage
cp CoachSource/Info.plist "$build_dir/Coach-Mac-Setup/Coach.app/Contents/Info.plist"
cp CoachSource/Resources/* "$build_dir/Coach-Mac-Setup/Coach.app/Contents/Resources/"
codesign --force --sign - "$build_dir/Coach-Mac-Setup/Coach.app"
(cd "$build_dir" && COPYFILE_DISABLE=1 zip -qr Coach-Mac-Setup.zip Coach-Mac-Setup)
mv "$build_dir/Coach-Mac-Setup.zip" Coach-Mac-Setup.zip
