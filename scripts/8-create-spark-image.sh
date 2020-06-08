#!/usr/bin/env bash
cd ${BASH_SOURCE%/*}/..

eval $(minikube docker-env)

sbt -DbaseRegistry=$(minikube ip):5000 clean docker


version=$(sbt -error showVersion)
relativeRegistry="localhost:5000"
docker tag  graphiq/transform-movie-ratings:0.1 ${relativeRegistry}/graphiq/transform-movie-ratings:${version}
docker push ${relativeRegistry}/graphiq/transform-movie-ratings:${version}


curl -s $(minikube ip):5000/v2/_catalog | jq
