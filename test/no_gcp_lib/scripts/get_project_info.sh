#!/bin/bash

tests="abc def"

mkdir ./test/no_gcp_lib/logs
gcloud config get-value core/project | tr -d "\n" > ./test/no_gcp_lib/logs/sample.txt

for test in $(echo $tests | cut -d ' ' -f 2); do
    echo $test
done
