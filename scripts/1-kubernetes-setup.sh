#!/usr/bin/env bash

brew cask install minikube
brew cask install VirtualBox
brew install kubernetes-cli

minikube addons enable dashboard
minikube addons enable registry

minikube start \
 --cpus 4 \
 --memory 8192 \
 --extra-config=apiserver.authorization-mode=RBAC \
 --insecure-registry=192.168.0.0/16 \
 --kubernetes-version=1.16.2

kubectl create clusterrolebinding add-on-cluster-admin \
 --clusterrole=cluster-admin \
 --serviceaccount=kube-system:default

kubectl cluster-info