Write-Host "---=== Build ===---"

Write-Host "--- Cleaning Cache ---"
flutter clean cache

Write-Host "--- Clean --"
flutter clean

Write-Host "--- Pub Get ---"
dart pub get

Write-Host "--- Build Runner ---"
dart run build_runner build -d

Write-Host "--- Build Web --"
flutter build web --base-href /
