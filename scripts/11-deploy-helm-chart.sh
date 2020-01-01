#!/usr/bin/env bash

cd ${BASH_SOURCE%/*}/..

eval $(minikube docker-env)

helm upgrade movie-ratings-transform \
 ./helm \
 -f ./helm/values-minikube.yaml \
 --namespace=spark-apps \
 --install \
 --force

helm repo add chartmuseum http://$(minikube ip):8080
helm repo update
helm upgrade movie-ratings-transform \
 chartmuseum/movie-ratings-transform \
 --namespace=spark-apps \
 --install \
 --force