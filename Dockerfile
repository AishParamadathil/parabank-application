# Step 1: Use the official Maven image with Eclipse Temurin JDK 17 to compile the application
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy all source files from your GitHub repository
COPY . .

# Build the project to generate target/parabank.war
RUN mvn clean package -DskipTests

# Step 2: Use Tomcat 10 running on JDK 17
FROM tomcat:10.1-jdk17-temurin

# Clean out default applications to make room for our deployment
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the compiled war file from the builder stage as ROOT.war
COPY --from=builder /app/target/parabank.war /usr/local/tomcat/webapps/ROOT.war

# Direct Tomcat's database and temp systems to use /tmp (fully writeable on Render)
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"

EXPOSE 8080
CMD ["catalina.sh", "run"]