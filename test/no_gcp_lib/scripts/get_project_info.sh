#!/bin/bash

tests="abc def"
tests2=(\
    "abc2"
    "def2"
)


# mkdir ./test/no_gcp_lib/logs
# gcloud config get-value core/project | tr -d "\n" > ./test/no_gcp_lib/logs/sample.txt

for test in $(echo $tests | tr ' ' '\n'); do
    echo $test
done

for t in ${tests2[@]} ; do
    echo $t
done
