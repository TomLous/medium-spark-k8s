#!/usr/bin/env bash

brew cask install minikube
brew cask install VirtualBox
brew install kubernetes-cli

minikube start \
 --cpus 4 \
 --memory 8192 \
 --extra-config=apiserver.authorization-mode=RBAC \
 --insecure-registry=localhost:5000 \
 --kubernetes-version=1.15.4

kubectl create clusterrolebinding add-on-cluster-admin \
 --clusterrole=cluster-admin \
 --serviceaccount=kube-system:default

kubectl cluster-info