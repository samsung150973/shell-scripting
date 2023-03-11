#!/bin/bash

<<COMMENT
if command used in 3 ways
    1) simple If
    2) If-Else
    3) Else-If

    if [ expression ] ; then
        command 1
    else
        command2
    fi

    Another Example is
        if [ expression ] ; then
        command 1
    elif
        [ expression ] ; then
        command2
    
    elif
        [ expression ] ; then
        command3
    else
        command 4
    fi
COMMENT

# examples

ACTION=$1

if [ "ACTION"== "start" ] ; then
    echo "payment starting"
    exit 0

elif [ "ACTION"=="stop" ] ; then
    echo "payment stopped"
    exit 1

else 
    echo "payment status unknown"
    exit 2
fi 