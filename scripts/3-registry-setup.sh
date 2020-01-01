#!/usr/bin/env bash

eval $(minikube docker-env)

echo "Already there?"

curl -s $(minikube ip):5000/v2/_catalog | jq
