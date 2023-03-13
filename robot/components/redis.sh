#!/bin/bash
echo "Redis automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=redis # to remove repetion of the name frontend. and also helps not to hardcode the filename

# initially to verify if you are root user . command -- sudi id -- will show the UID. 
# if UID is 0 , it is root user . to get only the UID 0 the command is -- sudo id -u --
# validating if root user

LOGFILE="/tmp/$COMPONENT.log"
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e " \e [31m login as root user \e[0m"
    exit 1
fi

# create a status check function
status() {

    if [ $1 -eq 0 ] ; then
        echo -e " \e[32m success \e[0m"
    else 
        echo -e " \e[31m failed  \e[0m"
        exit 2 # assiging exit code 
    fi

}



echo -n "confifuring $COMPONENT component"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo	&>> $LOGFILE
status $?

echo -n "installing $COMPONENT component"
yum install redis-6.2.11 -y	&>> $LOGFILE
status $?


# SED - stremline editor -- Deletes , substitues , Adds lines in the file
# vim /etc/redis.conf	
# vim /etc/redis/redis.conf	
echo -n "updating the ip address 127.0.0.1 in the $COMPONENT file"
sed -i -e 's/127.0.0.1/0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0/' /etc/redis/redis.conf
status $?


# restart the service
echo -n "daemon reload and restart the service"
systemctl daemon-reload             &>> $LOGFILE
systemctl enable $COMPONENT	        &>> $LOGFILE
systemctl restart $COMPONENT	    &>> $LOGFILE
systemctl status $COMPONENT -l	    &>> $LOGFILE
status $?
