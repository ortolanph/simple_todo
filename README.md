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

## Kubernetes

1. Install [kind](https://kind.sigs.k8s.io/)
2. With the docker image built, run the following command:

```
kind load docker-image flutter-todos-web --name todos-cluster
```

3. Run the `kubectl` to create the new infra:

```
kubectl create -f .\simple-todo-k8.yaml
```

4. Open a browser and access the [simple todo web](http://localhost:8081) address