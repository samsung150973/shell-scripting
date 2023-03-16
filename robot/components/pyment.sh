#!/bin/bash
echo "catalogue automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=payment # to remove repetion of the name frontend. and also helps not to hardcode the filename

source components/common.sh  # load the file of functions
PYTHON # calling Python function