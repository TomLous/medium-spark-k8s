#!/usr/bin/env bash
cd ${BASH_SOURCE%/*}/..

eval $(minikube docker-env)

sbt clean docker
