#!/usr/bin/env bash

eval $(minikube docker-env)

mkdir -p ~/.minikube/files/registry-data
docker run -d \
 --name registry \
 --restart=always \
 -p 5000:5000 \
 -v ~/.minikube/files/registry-data:/var/lib/registry \
 registry:2
