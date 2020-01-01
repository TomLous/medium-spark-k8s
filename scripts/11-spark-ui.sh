#!/usr/bin/env bash

kubectl port-forward -n spark-apps movie-ratings-transform-driver 4041:4040

open "http://localhost:4041"