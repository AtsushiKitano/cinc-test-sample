#!/bin/sh

gcloud config get-value core/project | tr -d "\n" > ./test/files/sample.txt
