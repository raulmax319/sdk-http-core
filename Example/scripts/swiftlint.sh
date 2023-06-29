#!/bin/sh

if uname -m | grep -q '^arm64'; then
    export PATH="$PATH:/opt/homebrew/bin"
fi
if which swiftlint >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi