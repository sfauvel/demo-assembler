#!/usr/bin/env bash
# Move to the folder and execute the script inside.


FOLDER="${1%/*}/"
SCRIPT="$(basename $1)"

pushd "${FOLDER}" > /dev/null
./${SCRIPT} "${@:2}"
popd > /dev/null