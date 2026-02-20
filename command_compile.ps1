Write-Host "---=== Compile ===---"

Write-Host "--- Cleaning Cache ---"
flutter clean cache

Write-Host "--- Clean --"
flutter clean

Write-Host "--- Pub Get ---"
dart pub get

Write-Host "--- Build Runner ---"
dart run build_runner build -d
