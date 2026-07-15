# 1. Start with the official prebuilt ParaBank image
FROM parasoft/parabank:latest

# 2. Clear out any default ROOT application to prevent conflicts
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# 3. Copy/Rename the war file from its distribution folder directly to ROOT.war
RUN cp /usr/local/tomcat/webapps.dist/parabank.war /usr/local/tomcat/webapps/ROOT.war

# 4. Force database and temp writes to go to /tmp to bypass Render's read-only blocks
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"