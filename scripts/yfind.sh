#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: yfind.sh dir filename key

Recursively search a directory for files of a given name (globbing supported),
and print the yaml values for a given key. For example, to find all chart
homepages in the helm-charts directory, run:

    yfind.sh ~/src/helm-charts Chart.yaml ".home"
'
    exit
fi

cd "$(dirname "$0")"

main() {
    local search_dir=$1
    local filename=$2
    local key=$3

    find "$search_dir" -name "$filename" -exec yq --no-doc "$key" {} \;
}

main "$@"
