@echo off
echo Building Flutter Android APK...
flutter build apk --release
echo APK built successfully! You can find it at:
echo build\app\outputs\flutter-apk\app-release.apk

echo.
echo Running app on connected device (if available)...
flutter run 