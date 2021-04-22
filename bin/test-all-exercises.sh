#!/bin/bash

set -euo pipefail

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

for exercise in "${exercise_dir}/practice/"*; do
    echo "Working on: ${exercise}"
    "${bin_dir}"/test-exercise.sh "${exercise}"
done
