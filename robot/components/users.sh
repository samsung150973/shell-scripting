#!/bin/bash
# user is same as catalogue . so copy and change componenet

echo "user automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=user # to remove repetion of the name frontend. and also helps not to hardcode the filename
APPUSER=roboshop

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

		
# 1	This service is written in NodeJS, Hence need to install NodeJS in the system.	
echo -n "configurring the NodeJS repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -	&>> $LOGFILE	
status $?

echo -n "installing Node JS :"
yum install nodejs -y		&>> $LOGFILE
status $?


# Creating a user roboshop normal user account ( first check if the user account exist)

id $APPUSER &>> $LOGFILE

if [ $? -ne 0 ] ; then
    
    echo -n "creating Application user account"
    useradd $APPUSER  &>> $LOGFILE
    status $?
fi

		
# 1	So let's switch to the	
# 	roboshop	
# 	user and run the following commands.	

echo -n "downloading the $COMPONENT component"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
status $?

echo -n "extracting the $COMPONENT in the $APPUSER directory"
cd /home/$APPUSER	

# delete the previous contents from previous downloads if any from the file
rm -rf /home/$APPUSER/$COMPONENT &>> $LOGFILE
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
status $?

# because the commands were execuret as root, the root previlages are provided
echo -n "moving the file and changing the permissions for $APPUSER"
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT	
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
status $?


# installing application
echo -n "installing application"
cd /home/$APPUSER/$COMPONENT		
npm install		&>> $LOGFILE
status $?
		
# 1	Update SystemD file with correct IP addresses	
# 	Update	MONGO_DNSNAME	with MongoDB Server IP	

echo -n "updating the systemd file with DB Details:"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service	
status $?



# Now, lets set up the service with systemctl.	

echo -n "starting the $COMPONENT service"
systemctl daemon-reload		&>> $LOGFILE
systemctl restart $COMPONENT		&>> $LOGFILE
systemctl enable $COMPONENT 	&>> $LOGFILE
systemctl status $COMPONENT -l	&>> $LOGFILE
status $?
