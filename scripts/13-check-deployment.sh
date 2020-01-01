#!/usr/bin/env bash

kubectl -n spark-apps get all

kubectl -n spark-apps logs pod/movie-ratings-transform-driver