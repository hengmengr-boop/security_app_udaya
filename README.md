# Udaya Visitor (Flutter)

Visitor management app for Udaya Technology. One codebase for **phone** (Android / iOS)
and **laptop** (Windows / macOS / Linux). English + Khmer.

## First-time setup

This package contains `lib/`, `assets/`, `pubspec.yaml` only. Generate the native
platform folders once:

```
setup.bat        (Windows)
./setup.sh       (macOS / Linux)
```

(or manually: `flutter create . --project-name udaya_visitor --org com.udaya
--platforms=android,ios,windows,macos,linux` then `flutter pub get`).
`flutter create` never overwrites your existing `lib/`.

## Run

```
flutter run -d windows      # laptop (or macos / linux)
flutter run                 # connected phone / emulator
```

Windows desktop needs **Developer Mode** on (Settings > For developers) for plugin symlinks.

API login: use the account provided by the company API administrator. Login also requires
the account's Google Authenticator code.

## Architecture (same as Flutter-Architecture)

```
Data source (SharedPreferences / Dio) -> Repository -> Bloc -> UI (BlocBuilder)

lib/
├── data/            models/VisitorModel · repositories/AuthRepo, VisitorRepo
├── helper/          global (C, Debouncer) · manager/language · preference/AppPreference
│                    style (AppColors, AppTheme, Dimen, CustomTextStyle, Assets)
│                    utils (router, navigator, theme, responsive)
├── logic/bloc/      AuthBloc · VisitorBloc
└── presentations/   items/ItemVisitor · modals (QR dialog, filter sheet)
                     pages/auth/LoginPage · pages/dashboard/VisitorPage · widgets


Responsive: `context.isMobile` (<600) / `isTablet` / `isWide` (>=900) in
`helper/utils/responsive_utils.dart`. Wide = sidebar + list, narrow = stacked.

