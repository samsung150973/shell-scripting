#!/bin/bash
echo "payment automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=payment # to remove repetion of the name frontend. and also helps not to hardcode the filename

source components/common.sh  # load the file of functions
PYTHON # calling Python function


# command $ cat payment/payment.ini will show the UID & GID as 1
# command $ id roboshop will show the uid  & GID as 1001 . this value should be mapped on payment.ini file





# Update the `roboshop` user id and group id in `payment.ini` file .

# ```sql
# # id roboshop 
# (Copy uid and gid of the user which needs to be updated in the payment.ini file )
# ```

# 1. Update SystemD service file with `CART` , `USER` , `RABBITMQ` Server IP Address.

# ```sql
# # vim systemd.service
# ```

# Update `CARTHOST` with cart server ip

# Update `USERHOST` with user server ip 

# Update `AMQPHOST` with RabbitMQ server ip.