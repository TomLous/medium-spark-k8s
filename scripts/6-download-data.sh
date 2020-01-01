#!/usr/bin/env bash

cd ${BASH_SOURCE%/*}/..

mkdir -p dataset
cd dataset
curl -L "http://files.grouplens.org/datasets/movielens/ml-20m.zip" -o ml-20m.zip
unzip ml-20m.zip
rm ml-20m.zip

