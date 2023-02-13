#! /bin/env bash

source ./build/function/package_fn.sh

function main() {
    stageTarget
    packageBooks

    echo $TARGET_PATH
}

main