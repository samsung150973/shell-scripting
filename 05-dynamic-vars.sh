#!/bin/bash

TODAYDATE="09/03/2023"
echo "today date is ${TODAYDATE}"

#To print in colours
echo -e "today date is \e[31m ${TODAYDATE} \e[0m"

# The date is static. To get current date the command is 

echo -e "CURRENT date is $(date +%F)"
# excho man date for more options

# display number of active sessions
echo "No of active sessions are : $(who | wc -l)"