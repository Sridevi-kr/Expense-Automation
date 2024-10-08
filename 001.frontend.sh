#!/bin/bash 

COMPONENT="frontend"
LOG="/tmp/frontend.log"

source common.sh   # This will pull all the functions and the available variables from this file and make it available locally to this script

if [ -f proxy.conf ] ; then # validating if proxy file is there or not
    COLOR Proxy File Presense 
    stat $? #$? This will show the exit code of the previous command. If the execution of the previous command is successful exit code is 0
    #if there is failure exit code is 1
else 
    echo -e "\e[31m proxy.conf is not present, ensure you supply it \e[0m"
    exit 1
fi 

COLOR Installing Ngnix
dnf install nginx -y  &>> $LOG
stat $?

COLOR Copying Proxy file
cp proxy.conf /etc/nginx/default.d/expense.conf &>> $LOG
stat $?

COLOR Enabling Nginx
systemctl enable nginx &>> $LOG
stat $?

COLOR Performing a Cleanup
rm -rf /usr/share/nginx/html/* &>> $LOG
stat $?

COLOR Downloading $COMPONENT
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/$COMPONENT.zip &>> $LOG
stat $?

cd /usr/share/nginx/html 
COLOR Extracting $COMPONENT 
unzip -o /tmp/$COMPONENT.zip &>> $LOG
stat $?

COLOR Starting $COMPONENT
systemctl restart nginx  &>> $LOG
stat $?

echo -e "\n\t** $COMPONENT Installation Is Completed **"