#!/usr/bin/env bash

cd ${BASH_SOURCE%/*}/..

name="transform-movie-ratings"

rm -rf output/${name}
mkdir output/${name}
cp -r helm/ output/${name}/
cat helm/values-minikube.yaml >> output/${name}/values.yaml
cd output

export HELM_REPO_USE_HTTP="true"
helm repo add chartmuseum http://$(minikube ip):8080
helm push  --force ${name}/ chartmuseum
