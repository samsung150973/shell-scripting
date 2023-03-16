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
# # grep temp /var/log/mysqld.log
# ( Copy that password )

# 1. Next, We need to change the default root password in order to start using the database service. Use password as `RoboShop@1` . Rest of the options you can choose `No`

# ```bash
# # mysql_secure_installation
# ```

# 1. You can check whether the new password is working or not using the following command in MySQL

# First let's connect to MySQL

# ```bash
# # mysql -uroot -pRoboShop@1
# ```

# Once after login to MySQL prompt then run this SQL Command. This will uninstall the password validation feature like number of characters, password length, complexty and all. As I don’t want that I’d be uninstalling the `validate_password` plugin

# ```sql
# > uninstall plugin validate_password;
# ```

# ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/584e54a9-29fa-4246-9655-e5666a18119b/Untitled.png)

# ## **Setup Needed for Application.**

# As per the architecture diagram, MySQL is needed by

# - Shipping Service

# So we need to load that schema into the database, So those applications will detect them and run accordingly.

# To download schema, Use the following command

# ```bash
# # curl -s -L -o /tmp/mysql.zip "https://github.com/stans-robot-project/mysql/archive/main.zip"
# ```

# Load the schema for mysql. This file contains the list of COUNTRIES, CITIES and their PINCODES. This will be helpful in doing the shipping charges calculation which is based on the distance the product is shippied

# ```bash
# # cd /tmp
# # unzip mysql.zip
# # cd mysql-main
# # mysql -u root -pRoboShop@1 <shipping.sql
# ```

# ![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/92634964-7621-49c9-ace2-fc8e47073237/Untitled.png)

# - 😀 We are good with MySQL now. Next move to the `SHIPPING` Component.

# `SHIPPING` consumes the information from MySQL.