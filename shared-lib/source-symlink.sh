#! /bin/bash

function scriptDir() {
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd
}

function ormosRoot() {
    git -C "$(scriptDir)" rev-parse --show-toplevel
}

function linkTo() {
    from="$1"
    dest="$2"
    repoRoot="$(ormosRoot)"
    cd "$repoRoot" || exit
    mkdir -p "$(dirname "$dest")"
    rm -f "$dest" && ln -s "$(realpath "$from")" "$dest"

    echo 'Linked!'
    echo "    -> ${from}"
    echo "    == ${dest}"
    cd - || exit
}
