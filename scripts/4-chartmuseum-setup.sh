#!/usr/bin/env bash

eval $(minikube docker-env)

mkdir -p ~/.minikube/files/chart-data

docker run -d \
  --name chart-museum \
  --restart=always \
  -p 8080:8080 \
  -v ~/.minikube/files/chart-data:/charts \
  -e DEBUG=true \
  -e STORAGE=local \
  -e STORAGE_LOCAL_ROOTDIR=/charts \
  chartmuseum/chartmuseum:v0.11.0

curl $(minikube ip):8080/index.yaml