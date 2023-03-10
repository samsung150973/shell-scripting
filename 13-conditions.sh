#!/bin/bash
# syntax for case

case $ACTION in
    start)
        echo "starting payment service"
        ;;
    stop)
        echo "stop payment service"
        ;;
    restart
        echo "restart the payment service"
        ;;


esac