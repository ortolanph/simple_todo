Write-Output "[---------------------- TODOS ----------------------]"

Write-Output ""
Write-Output "[CLEAN]"
Write-Output ""

flutter clean

Write-Output ""
Write-Output "[DEPENDENCIES]"
Write-Output ""

flutter pub get

Write-Output ""
Write-Output "[BUILD]"
Write-Output ""

flutter build web

Write-Output ""
Write-Output "[DOCKER LOGIN]"
Write-Output ""
docker login

Write-Output ""
Write-Output "[DOCKER BUILD]"
Write-Output ""
docker build -t flutter-todos-web .

Write-Output ""
Write-Output "[DOCKER RUN]"
Write-Output ""
docker run -d -p 8080:80 --name todos-web flutter-todos-web
