#!/usr/bin/env bash

eval $(minikube docker-env)

helm upgrade movie-ratings-transform \
 ./helm \
 -f ./helm/values-minikube.yaml \
 --namespace=spark-apps \
 --install \
 --force