#!/bin/bash
echo "rabbitmq automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=rabbitmq # to remove repetion of the name frontend. and also helps not to hardcode the filename

source components/common.sh  # load the file of functions

echo -n "installing Erlang Dependency :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>> $LOGFILE
status $?

echo -n " Configurring the repo :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
status $?

echo -n " Installing $COMPONENT :"
yum install rabbitmq-server -y &>> $LOGFILE
status $?

echo -n "starting $COMPONENT :"
systemctl enable rabbitmq.server  &>> $LOGFILE
systemctl start rabbitmq.server &>> $LOGFILE
status $?

echo -n "creating $COMPONENT Application User :"
rabbitmqctl add_user roboshop roboshop123  &>> $LOGFILE
status $?
