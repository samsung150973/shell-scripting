#!/bin/bash
echo "mysql automation script"
# set -e # exist the prog if any error (disabled with # as comment for this prog)

COMPONENT=mysql # to remove repetion ; also helps not to hardcode the filename
source components/common.sh


# As per the Application need, we are choosing MySQL 5.7 version. Setup MySQL Repo
echo -n " configurring the $COMPONENT repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo
status $?

# 1. Install MySQL
echo -n " Installing the $COMPONENT :"
yum install mysql-community-server -y &>> $LOGFILE
status $?


# 1. Start MySQL.
echo -n "enable & start the $COMPONENT :"
systemctl enable mysqld &>> $LOGFILE
systemctl start mysqld  &>> $LOGFILE # database must not be re-started evertime. lose the data
status $?


# 1. Now a default root password will be generated and can be seen in the log file.
# # grep temp /var/log/mysqld.log ( Copy that password ) - or below code willto capture the password in a variable
echo -n " fetching the default password"
DEFAULT_ROOT_PWD=$(grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
status $?


# Next, We need to change the default root password in order to start using the database service. Use password as `RoboShop@1` . Rest of the options you can choose `No`
# # mysql_secure_installation
# to automate changing the password
echo -n "Password reset of root user :"
# mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PWD}
#above will initiate the password reset option. below command will actually reset the password
# ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';
# above two can be combined as below ; with a condition that it should be changed once only
echo "show databases;" | mysql -uroot -pRoboshop@1 &>> $LOGFILE
if [ $? -ne 0 ] ; then

    echo -n "Password reset of root user"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Roboshop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PWD} &>> $LOGFILE
    status $?

fi

# Once after login to MySQL prompt then run this SQL Command. This will uninstall the password validation feature like number of characters, password length, complexty and all. As I don’t want that I’d be uninstalling the `validate_password` plugin
# using the same logic as above , the validation can be removed

echo "show plugins;" | mysql -uroot -pRoboshop@1 | grep validate_password  &>> $LOGFILE
if [ $? -eq 0 ] ; then
    echo -n "un-installing Password Validation Plugin :"
    echo "uninstall plugin validate_password;"| mysql -uroot -pRoboshop@1 &>> $LOGFILE
    status $?
fi

# dowload and injest the schema

echo -n "dowloading the $COMPONENT schema :"
curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip" &>> $LOGFILE
status $?

echo -n "extracting the schema"
cd /tmp
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
status $?

echo -n "inject the schema"
cd $COMPONENT-main
mysql -uroot -pRoboShop@1 < shipping.sql  &>> $LOGFILE
status $?