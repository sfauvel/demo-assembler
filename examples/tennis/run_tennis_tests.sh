#!/usr/bin/env bash

pushd ../..
. run_tests.sh "*" examples/tennis examples/tennis
popd
