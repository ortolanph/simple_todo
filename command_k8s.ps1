Write-Host "---=== K8S ===---"

$required = @("kind")

foreach ($prog in $required) {
    if (-not (Get-Command $prog -ErrorAction SilentlyContinue)) {
        Write-Error "Error: '$prog' is not installed or not in PATH"
        exit 1
    }
}

Write-Host "--- Create Cluster ---"
kind create cluster --name simple_todos_cluster

Write-Host "--- Load Docker Image ---"
kind load docker-image simple_todos:local --name simple_todos_cluster

Write-Host "--- Deploy Kubernetes ---"
kubectl create -f simple_todos-k8.yaml
