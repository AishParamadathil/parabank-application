"""FROM tomcat:10.1.57-jre21-temurin-noble

ARG TOMCAT_HOME=/usr/local/tomcat

USER root:root

COPY target/parabank.war ${TOMCAT_HOME}/webapps

# To enable injecting Virtualize JDBC driver into ParaBank
RUN apt update && \
    apt install unzip && \
    unzip ${TOMCAT_HOME}/webapps/parabank.war -d ${TOMCAT_HOME}/webapps/parabank && \
    rm ${TOMCAT_HOME}/webapps/parabank.war

EXPOSE 8080
EXPOSE 61616
EXPOSE 9001
"""

# 1. Start with the official prebuilt ParaBank image
FROM parasoft/parabank:latest

# 2. Rename the war file to ROOT.war so it hosts at the base URL (fixing the 404)
RUN mv /usr/local/tomcat/webapps/parabank.war /usr/local/tomcat/webapps/ROOT.war

# 3. Force database and temp writes to go to /tmp (fixing the HSQLDB crash)
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"