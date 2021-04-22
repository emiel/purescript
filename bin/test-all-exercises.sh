#!/bin/bash

set -euxo pipefail

if [ $# -eq 0 ]; then
    echo "usage: $0 /path/to/exercises"
    exit 1
fi

if [ ! -d "$1" ]; then
   echo "$1 is not a directory"
   exit 1
fi

exercise_dir=$1

bin_dir=$(dirname "$0")

for exercise in ${exercise_dir}/practice/*; do
    pushd $exercise
    spago init -f
    popd
    ${bin_dir}/test-example.sh $exercise
done
