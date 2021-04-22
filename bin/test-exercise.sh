#!/bin/bash

set -euxo pipefail

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

cleanup() {
    rm -r "${build_dir}"
}

# trap cleanup EXIT INT TERM

pushd "$build_dir"
echo "Testing ${exercise_slug} in ${exercise_dir}..."
spago test
exit $?
