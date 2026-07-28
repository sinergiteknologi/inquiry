#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="${HOME}/flutter"
FLUTTER_CHANNEL="stable"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_CHANNEL" --depth 1 "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true

flutter config --enable-web --no-analytics
flutter precache --web --no-android --no-ios --no-linux --no-macos --no-windows
flutter pub get
flutter build web --release --base-href / --no-wasm-dry-run
