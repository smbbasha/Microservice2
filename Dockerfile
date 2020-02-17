FROM tomcat:8.0
MAINTAINER Sandeep
COPY target/petclinic.war /usr/local/tomcat/webapps/

