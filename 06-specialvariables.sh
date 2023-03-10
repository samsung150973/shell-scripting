
# special Characters are: $0 to $9 , $* ,#@, $$
# $0 gives the current script name in execution
echo  "Name of the current script is : $0"

# To Supply value to a variables from command line is by using £1 to $9
echo  "Name of the current script is : $1"
echo  "Name of the current script is : $2"
echo  "Name of the current script is : $3"
# when the command is executed , supply the values to 1,2,3 as bash -06-specialvariables.sh 100 200 300
# then run again the scipt to see the values are assigned
echo "supplied variables are $*"
echo "total number of argumanets / values supplies on command line $#"
echo "supplied variables are $@"
echo "current process id $$"
echo " exit code status of previous command $?" 