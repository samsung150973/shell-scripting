#!/bin/bash
# syntax for case

ACTION=$1 # gives the value of 1st argumemnt supplied on command line
case $ACTION in
    start)
        echo "starting payment service"
        ;;
    stop)
        echo "stop payment service"
        ;;
    restart)
        echo "restart the payment service"
        ;;
    *)
        echo -e "valid options are \e[32m Start or Stop or restart \g[0m"
        ;;
esac