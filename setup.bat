@echo off
REM One-time setup: generates the platform folders (android, ios, windows, macos, linux)
REM next to your existing lib/, installs packages and builds icon + splash.
call flutter create . --project-name udaya_visitor --org com.udaya --platforms=android,ios,windows,macos,linux
if errorlevel 1 goto :err
call flutter pub get
if errorlevel 1 goto :err
call dart run flutter_launcher_icons
call dart run flutter_native_splash:create
echo.
echo Done.  Laptop : flutter run -d windows
echo        Phone  : connect phone (USB debugging) then: flutter run
goto :eof
:err
echo Setup failed - check the message above.
