#!/usr/bin/env bash

set -o pipefail
set -u

if [ $# != 1 ]; then
    echo "Usage ${BASH_SOURCE[0]} /path/to/exercises"
    exit 1
fi

base_dir=$(builtin cd "${BASH_SOURCE%/*}/.." || exit; pwd)
exercises_dir="${1%/}"
spago="npx spago"

#
# Keep these dependencies in sync with the Exercism Purescript test runner.
# See: https://github.com/exercism/purescript-test-runner/blob/main/pre-compiled/spago.dhall
#
dependencies=(
  "arrays"
  "console"
  "datetime"
  "effect"
  "either"
  "enums"
  "foldable-traversable"
  "integers"
  "lists"
  "math"
  "maybe"
  "ordered-collections"
  "partial"
  "prelude"
  "psci-support"
  "strings"
  "test-unit"
  "tuples"
  "unfoldable"
  "unicode"
)

package_set_tag="psc-0.14.7-20220418"

project_dir="${base_dir}/my-project"

# Build a sample project

if [[ -e "${project_dir}" ]]; then
    rm -rf "${project_dir}"
fi

mkdir "${project_dir}" && pushd "${project_dir}" || exit

${spago} init --no-comments --tag "${package_set_tag}"
for dep in "${dependencies[@]}"; do
    ${spago} install "${dep}"
done

popd || exit

# Update exercises from sample project

for config in "$exercises_dir"/*/*/spago.dhall; do
    exercise_dir=$(dirname "${config}")
    slug=$(basename "${exercise_dir}")

    echo "Working in ${exercise_dir}..."

    sed -e "s/my-project/${slug}/" < "${project_dir}/spago.dhall" > "${exercise_dir}/spago.dhall"
    cp "${project_dir}/packages.dhall" "${exercise_dir}/packages.dhall"
done
