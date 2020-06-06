#!/usr/bin/env bash

brew cask install minikube
brew cask install VirtualBox
brew install kubernetes-cli

minikube start --bootstrapper=kubeadm --cpus 4 --memory 8192 --insecure-registry=192.168.0.0/16

minikube addons enable registry

kubectl create clusterrolebinding add-on-cluster-admin \
 --clusterrole=cluster-admin \
 --serviceaccount=kube-system:default

kubectl cluster-info