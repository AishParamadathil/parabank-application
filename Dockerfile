# Step 1: Compile with JDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy source files
COPY . .

# Build the project (generates parabank.war)
RUN mvn clean package -DskipTests

# Step 2: Run on official Tomcat 10.1 (Required for Jakarta EE / Servlet 6.0)
FROM tomcat:10.1-jdk17-temurin-jammy

# Clean out default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the compiled war file directly as ROOT.war so it serves on the base URL "/"
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Direct Tomcat's database and temp systems to use /tmp (fully writeable on Render)
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"

# Explicitly expose only the web port
EXPOSE 8080

CMD ["catalina.sh", "run"]