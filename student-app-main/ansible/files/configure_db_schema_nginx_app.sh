#!/bin/bash

LOG=/tmp/devops.txt

# DB schemas 
cd /tmp/ && git clone https://gitlab.com/rns-app/student-app.git
mysql -uroot < /tmp/student-app/dbscript/studentapp.sql

# Nginx Static Application Deployment
sudo rm -rf /usr/share/nginx/html/* &>>$LOG
cd /tmp/
git clone https://gitlab.com/rns-app/static-project.git
sudo cp -R /tmp/static-project/iPortfolio/* /usr/share/nginx/html

sudo sed -i -e '/location \/student/,+3 d' -e '/^        error_page 404/ i \\t location /student { \n\t\tproxy_pass http://localhost:8080/student;\n\t}\n' /etc/nginx/nginx.conf

sudo systemctl enable nginx &>>$LOG
sudo systemctl restart nginx &>>$LOG
