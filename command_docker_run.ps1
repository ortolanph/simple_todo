Write-Host "---=== Docker Run ===---"
command_build.ps1

Write-Host "--- Docker Run ---"
docker run -d -p 8080:80 --name todos-web flutter-todos-web