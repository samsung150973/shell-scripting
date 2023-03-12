#!/bin/bash
echo "Mongodb automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=mongodb # to remove repetion of the name frontend. and also helps not to hardcode the filename

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
        echo -e " \e[32m successfully installed Nginx \e[0m"
    else 
        echo -e " \e[31m failed installing Nginx \e[0m"
        exit 2 # assiging exit code 
    fi

}

# execute as root user prefix sudo in command line to install ngiix and start the service

echo -e "Configuring the $COMPONENT "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
status $?

echo -n "installing the $COMPONENT"
yum install -y mongodb-org &>> $LOGFILE
status $?

echo -n "Enable & Start the $COMPONENT"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod &>> $LOGFILE
status $?


# SED - stremline editor -- Deletes , substitues , Adds lines in the file
echo -n "updating the ip address 127.0.0.1 in the $COMPONENT file"
sed -i -e 's/127.0.0.1/0.0.0/' /etc/mongod.conf
status $?


# performing daemon reload
echo -m "performing daemon reload and restart mongo"
systemctl daemon-reload &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
status $?

# Every Database needs the schema to be loaded for the application to work.
echo -n "Downloading the $COMPONENT schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
status $?

echo -n "Extracting the $COMPONENT schema"
cd /tmp
unzip -o mongodb.zip &>> $LOGFILE # unzip -o will overwrite the file without confirmation
ststus $?


echo -n "injecting the $COMPONENT schema"
cd /tmp/$COMPONENT.main
# cd mongodb-main
mongo < catalogue.js &>> $LOGFILE
mongo < users.js &>> $LOGFILE
ststus $?
