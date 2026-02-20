Write-Host "---=== Docker Build ===---"

command_build.ps1

Write-Host "--- Docker Login --"
docker login

Write-Host "--- Docker Build ---"
docker build -t flutter-todos-web .