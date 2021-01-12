#!/bin/sh

mkdir ./test/logs
gcloud config get-value core/project | tr -d "\n" > ./test/logs/sample.txt
