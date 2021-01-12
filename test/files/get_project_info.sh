#!/bin/sh

gcloud config get-value core/project | tr -d "\n" > ./files/sample.txt
