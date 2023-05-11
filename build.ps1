function Print-Banner {

    param (
        $Stage, $PhaseName
    )

    Write-Output ""
    Write-Output "[$Stage][$PhaseName]"
    Write-Output ""

}

Write-Output "[---------------------- TODOS ----------------------]"

Print-Banner -Stage "FLUTTER" -PhaseName "CLEAN"
flutter clean

Print-Banner -Stage "FLUTTER" -PhaseName "DEPENDENCIES"
flutter pub get

Print-Banner -Stage "FLUTTER" -PhaseName "BUILD"
flutter build web

Print-Banner -Stage "DOCKER" -PhaseName "LOGIN"
docker login

Print-Banner -Stage "DOCKER" -PhaseName "BUILD"
docker build -t flutter-todos-web .

Print-Banner -Stage "DOCKER" -PhaseName "RUN"
docker run -d -p 8080:80 --name todos-web flutter-todos-web
