Write-Host "---=== Build ===---"
command_compile.ps1

Write-Host "--- Build Web --"
flutter build web --base-href /
