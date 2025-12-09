#!/bin/bash

./make.sh; while true; do inotifywait -q -r -e create,modify,delete .; ./make.sh; echo "Last run: $(date +%H:%m:%S)"; done;
