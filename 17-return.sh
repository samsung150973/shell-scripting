#!/bin/bash
# Exit will get out of the script
# return - will get out of the function called

sample() {
    echo " I am a function named sample"
}
    
stat() {    
    echo " Today date is $(date +%F)"
    echo " system uptime is $(uptime)"
    echo " awk -F is a function used with field seperator"
    echo " first value of uptime command output is  $(uptime | awk -F : '{print $01}')"
    echo " last field of the uptime command output is $(uptime | awk -F : '{print $NF}')"
    echo " first value from load average is $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"

    echo "calling sample function"
    sample
}

stat 

echo "stat and sample function executed"