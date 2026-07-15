# Step 1: Compile with JDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy all source files from your GitHub repository
COPY . .

# Build the project to generate the target/*.war file
RUN mvn clean package -DskipTests

# Step 2: Run on Tomcat 9 with JDK 11
FROM tomcat:9.0-jdk11-openjdk

# Clean out default applications to make room for our deployment
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the compiled war file keeping its original name 'parabank.war'
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/parabank.war

# Create a simple, lightweight default ROOT index that instantly redirects root traffic (/) to /parabank/
RUN mkdir /usr/local/tomcat/webapps/ROOT && \
    echo '<% response.sendRedirect("/parabank/"); %>' > /usr/local/tomcat/webapps/ROOT/index.jsp

# Direct Tomcat's database and temp systems to use /tmp (fully writeable on Render)
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"

EXPOSE 8080
CMD ["catalina.sh", "run"]