#!/bin/bash

## add user
USERNAME=$1
if [[ -z "$USERNAME" ]]; then
    echo "Please give me a username"
    exit 1
fi
printf "Allocating space for $USERNAME...\n"
workspace_path=/home/Workspace/$USERNAME
mkdir -p $workspace_path
printf "Workspace path: $workspace_path \n"
log_path=/mnt/Storage/Log/$USERNAME
mkdir -p /mnt/Storage/Log/$USERNAME
printf "Log path: $log_path \n"
source_path=/mnt/Storage/Source
printf "Source path: $source_path \n"

## allocate port
PORT=$2
note=$3
ufw allow $PORT
#echo "Port $PORT" >> /etc/ssh/sshd_config
#echo "ListenAddress 0.0.0.0:$PORT" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart
printf "Allocating port $PORT for $USERNAME.\n"

## create docker image
printf "Create Docker Image..."
docker build -t deepbrain:$USERNAME .


## start docker container
printf "Start Docker Container..."
nvidia-docker run -d -p $PORT:22 -p $note:8888 --ipc=host -v $workspace_path:/root/Workspace -v $log_path:/root/log -v $source_path:/root/Source deepbrain:$USERNAME /usr/sbin/sshd -D 
