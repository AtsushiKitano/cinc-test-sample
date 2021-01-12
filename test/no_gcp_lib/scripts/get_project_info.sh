#!/bin/sh

mkdir ./test/no_gcp_lib/logs
gcloud config get-value core/project | tr -d "\n" > ./test/no_gcp_lib/logs/sample.txt
