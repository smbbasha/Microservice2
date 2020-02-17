FROM tomcat:8.0
MAINTAINER Sandeep
COPY var/lib/jenkins/workspace/PetclinicDemo301/target/petclinic.war /usr/local/tomcat/webapps/

