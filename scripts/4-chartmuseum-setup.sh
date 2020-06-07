#!/usr/bin/env bash

eval $(minikube docker-env)

cd ${BASH_SOURCE%/*}/..

docker run -d \
  --name chartmuseum \
  --restart=always \
  -p 8080:8080 \
  -e DEBUG=true \
  -e STORAGE=local \
  -e STORAGE_LOCAL_ROOTDIR=/home/chartmuseum/charts \
  chartmuseum/chartmuseum:v0.12.0

curl $(minikube ip):8080/index.yaml