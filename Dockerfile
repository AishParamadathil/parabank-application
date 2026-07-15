
# 1. Start with the official prebuilt ParaBank image
FROM parasoft/parabank:latest

# 2. Rename the war file to ROOT.war so it hosts at the base URL (fixing the 404)
RUN mv /usr/local/tomcat/webapps/parabank.war /usr/local/tomcat/webapps/ROOT.war

# 3. Force database and temp writes to go to /tmp (fixing the HSQLDB crash)
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"