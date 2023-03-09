#!/bin/bash

TODAYDATE="09/03/2023"
echo "today date is ${TODAYDAYE}"

#To print in colours
echo -e "today date is \e[32m ${TODAYDATE} \e[0m"

# The date is static. To get current date the command is 

sysdate="Today date is ${date +%F}"
