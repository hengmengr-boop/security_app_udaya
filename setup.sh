#!/usr/bin/env bash
# One-time setup: generates the platform folders next to your existing lib/,
# installs packages and builds icon + splash.
set -e
flutter create . --project-name udaya_visitor --org com.udaya --platforms=android,ios,windows,macos,linux
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
echo
echo "Done.  Laptop: flutter run -d macos | linux      Phone: flutter run"
