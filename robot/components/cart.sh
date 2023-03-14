#!/bin/bash
echo "user automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)
COMPONENT=user # to remove repetion of the name frontend. and also helps not to hardcode the filename
source components/common.sh # calls the functions file
NODEJS

