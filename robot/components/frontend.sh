#!/bin/bash
echo "Frontend automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

# initially to verify if you are root user . command -- sudi id -- will show the UID. 
# if UID is 0 , it is root user . to get only the UID 0 the command is -- sudo id -u --
# validating if root user
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

echo -n "installing Nginx" #-n will keep the curser in the same line
yum install nginx -y &>> /tmp/frontend.log

stat $?  # this will give the first argument which will be supplied to the stat function $1

# download the HTDOCS content and deploy it under the Nginx path.
echo -n "Downloding the frontend component"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

stat $?

#Deploy in Nginx Default Location.

echo -n "performing cleanup of old frontend content"
cd /usr/share/nginx/html
rm -rf * &>> /tmp/frontend.log

stat $?


echo -n "copying the downloaded new frontend"
unzip /tmp/frontend.zip &>> /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

stat $?


# enable Nginx
echo -n "stating the Nginx service"
systemctl enable nginx &>> /tmp/frontend.log

# restart Nginx
systemctl restart nginx

stat $?


# observations
# 1 steps that failed - the script should stop -- set -e  (to exit the programme - break behaviour)
# 2 installation failed as root user preveledge was not verified
# 3 scrip progress need not dispaled 
