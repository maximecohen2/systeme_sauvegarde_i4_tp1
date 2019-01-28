#!/bin/bash

programName=$(basename $0)


usage() {

    echo "usage: $programName "
    exit 1
}

save() {
    exit 0
}

if [[ $# == 0 ]] || [[ $1 == '-h' ]]; then
    usage
elif [[ $# -eq 1 ]]; then
    save
else
    echo "ERROR: Bad arguments"
    usage
fi

