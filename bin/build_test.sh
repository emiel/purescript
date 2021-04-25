#!/usr/bin/env bash

# Setup shared .spago and output directories

set -e
set -u
set -o pipefail

if [ $# -eq 0 ]; then
    echo "usage: $0 /path/to/exercises"
    exit 1
fi

build_dir="./build"

if [ -d ${build_dir} ]; then
    rm -rf ${build_dir}
fi

mkdir -p "${build_dir}"/{_output,_spago}

cp -R ./exercises/practice "${build_dir}"

for exercise_dir in "${build_dir}/practice/"*; do
    exercise_slug=$(basename "${exercise_dir}")

    echo "***"
    echo "*** Working on practice/${exercise_slug}"
    echo "***"

    pushd "${exercise_dir}"

    cp ./examples/src/*.purs ./src

    # Use a shared output and .spago directory to avoid rebuilding shared
    # dependencies. These directories are ideal candidates for caching on
    # GitHub CI...
    ln -s ../../_output ./output
    ln -s ../../_spago ./.spago

    # XXX(emiel) Go for real pascal case
    exercise_pascal=$(echo "${exercise_slug}" | tr '[:lower:]' '[:upper:]' | sed -e "s/-//g")

    # Substitute generic module name to avoid module name clash in test modules
    cp ./test/Main.purs ./test/Main.purs.orig
    sed "s/module Test.Main/module Test.${exercise_pascal}/" < ./test/Main.purs.orig > ./test/Main.purs

    # Execute the test
    spago test -m "Test.${exercise_pascal}"

    popd
done
