#!bin/bash


LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

# validating if root user
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

CREATE_USER() {
# Creating a user roboshop normal user account ( first check if the user account exist)

id $APPUSER &>> $LOGFILE

if [ $? -ne 0 ] ; then
    
    echo -n "creating Application user account"
    useradd $APPUSER  &>> $LOGFILE
    status $?
fi
}

DOWNLOAD_AND_EXTRACT(){
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
}

NPM_INSTALL(){
    # installing application
    echo -n "installing application"
    cd /home/$APPUSER/$COMPONENT		
    npm install		&>> $LOGFILE
    status $?
}


CONFIG_SVC() {

# 1	Update SystemD file with correct IP addresses. Update	MONGO_DNSNAME	with MongoDB Server IP	

echo -n "updating the systemd file with DB Details:"
sed -i -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/CART.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service	
status $?

# Now, lets set up the service with systemctl.	
echo -n "starting the $COMPONENT service"
systemctl daemon-reload		&>> $LOGFILE
systemctl restart $COMPONENT		&>> $LOGFILE
systemctl enable $COMPONENT 	&>> $LOGFILE
systemctl status $COMPONENT -l	&>> $LOGFILE
status $?
}

MVN_PACKAGE() {
    echo -n "creating the $COMPONENT package :"
    cd /home/$APPUSER/$COMPONENT/
    mvn clean package &>> LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    status $?
}


PYTHON(){
echi -n "Installing python and dependencies" 
yum install python36 gcc python3-devel -y &>> $LOGFILE
status $?

# calling creae -user function
CREATE_USER

# calling Download And Extract function
DOWNLOAD_AND_EXTRACT

echo -n " Installing $COMPONENT 
cd /home/roboshop/$COMPONENT/
pip3 install -r requirements.txt &>>LOGFILE
status $?

}



JAVA() {
    echo -n "Install Maven :"
    yum install maven -y &>>LOGFILE
    status $?

# calling creae -user function
CREATE_USER

# calling Download And Extract function
DOWNLOAD_AND_EXTRACT

# calling maven package
MVN_PACKAGE

# calling config Service
CONFIG_SVC

}


NODEJS() {
# 1	This service is written in NodeJS, Hence need to install NodeJS in the system.	
    echo -n "configurring the NodeJS repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -	&>> $LOGFILE	
    status $?

    echo -n "installing Node JS :"
    yum install nodejs -y		&>> $LOGFILE
    status $?

# calling create user function
CREATE_USER

# calling Download And Extract function
DOWNLOAD_AND_EXTRACT

# Calling NPM Install
NPM_INSTALL

# calling config Service
CONFIG_SVC

}