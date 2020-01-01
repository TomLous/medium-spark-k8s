#!/usr/bin/env bash
cd ${BASH_SOURCE%/*}/..

sbt docker
