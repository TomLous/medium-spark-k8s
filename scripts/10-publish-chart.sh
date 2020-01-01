#!/usr/bin/env bash

cd ${BASH_SOURCE%/*}/..

name="transform-movie-ratings"

mkdir output/${name}
cp -r helm/ output/${name}/
cat helm/values-minikube.yaml >> output/${name}/values.yaml
cd output

helm repo add chartmuseum http://$(minikube ip):8080
helm push ${name}
