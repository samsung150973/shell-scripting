#!/bin/bash
# https://docs.aws.amazon.com/cli/latest/reference/ec2/  ( reference)
# aws ec2 describe-images --region us-east-1 --image-ids ami-0c1d144c8fdd8d690
# aws ec2 run-instances --image-id ami-0c1d144c8fdd8d690 --instance-type t2.micro  ( To create an EC2 instance)
# how to get the AMI-ID  ( create a new image ; the ID will change even if same AMI used)
AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId')
echo -n "AMI ID is $AMI_ID"

# to get AMI ID Only without Quotes
AMI_ID=$(aws ec2 describe-images --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
echo -n "AMI ID without quotes is $AMI_ID"
