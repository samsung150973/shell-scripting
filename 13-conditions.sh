#!/bin/bash
# syntax for case

ACTION=$1 # gives the value of 1st argumemnt supplied on command line
case $ACTION in
    start)
        echo "starting payment service"
        exit 0 # exit means it comes out of loop. the exit code is defined by user to be 0
        ;;
    stop)
        echo "stop payment service"
        exit 2 # exit code defined by user as 2 after the condition is true
        ;;
    restart)
        echo "restart the payment service"
        exit 3
        ;;
    *)
        echo -e "valid options are \e[32m Start or Stop or restart \g[0m"
        exit 4
        ;;
esac

# command is  git pull ; script.sh start/stop/restart option as 1st argument 
# after execution if user types $? to know the status of previous comamnd, it will output the user defined code +command not found