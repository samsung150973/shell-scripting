#!/bin/bash
# how to fetch the exit status of last executed command
# $?
# exit code 0 -> successful 
# exit code 1 - 255 error code (partial success, complete failure)
# exit codes from 126 - 255 used by system
# makes debugging easy