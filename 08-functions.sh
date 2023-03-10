#!/bin/bash

#
# binary  command           (called from /bin or /sbin e.g command -- type cat --  will show the dir name of cat process)
# aliaises command          (are shortcuts -- alias gp="get pull")
# shell built-in command    (e.g command -- type cd --   or ---type export --)
# functions                 ( set of comamnds in a seq - to be called-in when required)

# Declaring a function

sample() {
    echo " I am a function"
    echo " Today date is $(date +%F)"
    echo " system uptime is $(uptime)"
    echo " awk -F is a function used with field seperator"
    echo " first value of uptime command output is  $(uptime | awk -F : '{print $01}')"
    echo " last field of the uptime command output is $(uptime | awk -F : '{print $NF}')"
    echo " load average from uptime is $(uptime | awk -F : '{print $NF}' | awk -F , `{print $1}`)"
}
sample
