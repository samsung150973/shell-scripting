#!/bin/bash
# https://docs.aws.amazon.com/cli/latest/reference/ec2/  ( reference)
# aws ec2 describe-images --region us-east-1 --image-ids ami-0c1d144c8fdd8d690
# aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type t2.micro  ( To create an EC2 instance)
# how to get the AMI-ID  ( create a new image ; the ID will change even if same AMI used)
# AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId')
# echo -n "AMI ID is $AMI_ID "


# COMPONENT value to be supplied by the user ; e.g catalogue, cart, mysql etc 
 if  [ -z "$1" ] ; then 
    echo -e "\e[31m component name required \e[0m \t\t"
    echo -e "sample usage is: $ bash create-ec2.sh user"
    exit 1
fi

HOSTEDZONEID="Z051395110ZYXTFNQGVKT"
COMPONENT=$1


# to get AMI ID Only without Quotes
AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
echo -n "AMI ID without quotes is $AMI_ID : "

# to fetch the security id, to be added to the ec2 instnce . We need the Group ID info from the security group
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b53-allow-all-mm  | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')
echo -n "SGID ID without quotes is $SGID : "

echo -n "launching the instance with $AMI_ID as AMI : "

create_server() {

 echo "****** LAUNCHING $COMPONENT Server **** "

    IPADDRESS=$(aws ec2 run-instances --image-id $AMI_ID \
                    --instance-type t3.micro \
                    --security-group-ids $SGID \
                    --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
                    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')


    # search with value component and replace with $COMPONENT and search for IPaddress & change the ipaddress; the value from the file record.json
    echo $IPADDRESS
    sed -e "s/COMPONENT/${COMPONENT}/" -e  "s/IPADDRESS/${IPADDRESS}/" robot/record.json > /tmp/record.json
    aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/record.json | jq

}



   



if [ "$1" == "all" ] ; then 
    for component in frontend mongodb catalogue cart user mysql redis rabbitmq shipping payment ; do 
        COMPONENT=$component 
        create_server
    done
else 
    create_server
fi