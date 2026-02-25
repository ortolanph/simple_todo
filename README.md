# simple_todo

A (not so) simple todo made in flutter that will be deployed into a docker Container.

## Requirements

* Flutter
* Docker

## How to build

On a command line, type the following commands: 

```shell
make help
make compile

```

To see the help of what can be done.

Or, in Windows:

```powershell
.\command_help.ps1          - Shows this help
.\command_compile.ps1       - Compiles the project
.\command_build.ps1         - Builds the project
.\command_fix.ps1           - Runs dart analyze and dart fix
.\command_docker_build.ps1  - Builds the docker image locally
.\command_docker_run.ps1    - Runs docker locally
.\command_docker_upload.ps1 - Upload a new version of docker image (requires version parameter)
.\command_kubernetes.ps1    - Create local Kubernetes deployments with kind
```

## Kubernetes

1. Install [kind](https://kind.sigs.k8s.io/)
2. Create Cluster

```shell
kind create cluster --name todos-cluster
```

3. With the docker image built, run the following command:

```shell
kind load docker-image flutter-todos-web --name todos-cluster
```

4. Run the `kubectl` to create the new infra:

```shell
kubectl create -f .\simple-todo-k8.yaml
```

5. Open a browser and access the [simple todo web](http://localhost:8081) address
