#!/bin/bash

# Run the exercise tests against the example solution.

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "usage: $0 /path/to/exercise/slug"
    exit 1
fi

if [ ! -d "$1" ]; then
   echo "$1 is not a directory"
   exit 1
fi

exercise_dir=$1
exercise_slug=$(basename "$exercise_dir")
examples_dir="$exercise_dir/examples"
build_dir=$(pwd)/build/${exercise_slug}

mkdir -p "${build_dir}"

cp -R -L \
    "${exercise_dir}/packages.dhall" \
    "${exercise_dir}/spago.dhall" \
    "${exercise_dir}/test" \
    "${examples_dir}/src" \
    "${build_dir}"

pushd "$build_dir"
time spago install
time spago build
time spago test
exit $?
