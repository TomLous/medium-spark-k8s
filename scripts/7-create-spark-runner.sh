#!/usr/bin/env bash

name="spark-runner"
cd ${BASH_SOURCE%/*}/../docker/${name}

eval $(minikube docker-env)

name="spark-runner"
registry="localhost:5000"
version="0.1"

docker build \
    --build-arg VCS_REF=$(git rev-parse --short HEAD) \
    --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    --build-arg VERSION=0.1 \
    -t ${registry}/${name}:${version} . \
&& docker push ${registry}/${name}:${version} \
&& echo "Build & pushed ${registry}/${name}:${version}"


curl -s $(minikube ip):5000/v2/_catalog | jq