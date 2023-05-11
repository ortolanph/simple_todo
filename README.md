# simple_todo

A (not so) simple todo made in flutter that will be deployed into a docker Container.

## Requirements

* Flutter
* Docker

## How to build

On a command line, type the following commands: 

```shell
flutter clean
flutter pub get
flutter build web
docker login
docker build -t flutter-todos-web .
docker run -d -p 8080:80 --name todos-web flutter-todos-web
```

Or, in Windows:

```powershell
.\build.ps1
```