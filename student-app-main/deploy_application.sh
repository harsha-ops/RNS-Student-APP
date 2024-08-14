#! /bin/bash

# sudo setsebool -P httpd_can_network_connect 1
sudo su - devops -c "git config --global --add safe.directory '*'"

git pull origin main

mysql -uroot < ./dbscript/studentapp.sql

# Manager's App Context XML

cp ./tomcat/manager/context.xml /opt/appserver/webapps/manager/META-INF

# Add User to Tomcat

cp ./tomcat/conf/tomcat-users.xml /opt/appserver/conf/

# Load DB Driver

cp ./tomcat/lib/mysql-connector.jar /opt/appserver/lib/

# Integrate Tomcat with DB

cp ./tomcat/conf/context.xml /opt/appserver/conf/

# Restart the Tomcat SErvice

sudo systemctl stop tomcat
sudo systemctl start tomcat

# Deploying Student App


# echo 2 | sudo alternatives --config java

# sudo su - devops -c "mvn clean package"

# echo '1' | sudo alternatives --config java

cp ./target/*.war /opt/appserver/webapps/student.war

# Nginx static app deployment

#cd /usr/share/nginx/html/

sudo rm -rf /usr/share/nginx/html/*

# cd /opt/

# cd /opt/static-project/iPortfolio/

sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html/

# Reverse Proxy Configuration

sudo cp ./nginx/nginx.conf /etc/nginx/

sudo systemctl stop nginx
sudo systemctl start nginx
