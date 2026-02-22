param(
    [Parameter(Mandatory=$true)]
    [string]$versionString
)

Write-Host "---=== Docker Upload ===---"

Write-Host "--- Docker Login ---"
docker login

Write-Host "--- Docker Build ---"
Write-Host "[BUILD THE PROJECT FIRST]"
docker build -t simple_todos:$versionString .

Write-Host "--- Docker Tagging ---"
docker tag simple_todos:$versionString ortolanph/simple_todos:$versionString
docker tag simple_todos:$versionString ortolanph/simple_todos:latest

Write-Host "--- Docker Pushing ---"
docker push ortolanph/simple_todos:$versionString
docker push ortolanph/simple_todos:latest
