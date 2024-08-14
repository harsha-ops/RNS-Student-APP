FROM    tomcat:8.5
ADD     student.war webapps/student.war 
COPY     mysql-connector.jar lib/mysql-connector.jar 
COPY    context.xml conf/context.xml 
COPY    catalina.sh bin/catalina.sh 
RUN     chmod +x bin/catalina.sh 
