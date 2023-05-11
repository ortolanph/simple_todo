Write-Output "[---------------------- TODOS ----------------------]"
Write-Output "[CLEAN]"
flutter clean
Write-Output "[DEPENDENCIES]"
flutter pub get
Write-Output "[BUILD]"
flutter build web
Write-Output "[DOCKER BUILD]"
docker build -t flutter-todos-web .
Write-Output "[DOCKER RUN]"
docker run -d -p 8080:80 --name flutter-todos-web todos-web
