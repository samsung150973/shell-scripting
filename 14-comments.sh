#!bin/bash

echo "Devops Batch 53"
echo "Demo of multi line comments"

<<COMMENT # these commands are ignored. not executed
a=10
echo $a
echo " I am printing $a"
COMMENT