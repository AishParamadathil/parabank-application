# Step 1: Use an official Maven/Java image to build the project
FROM maven:3.8.6-openjdk-11 AS builder
WORKDIR /app

# Copy all source files from your GitHub repository into the builder container
COPY . .

# Run the Maven build to package the application into a .war file
RUN mvn clean package -DskipTests

# Step 2: Use a clean, standard Tomcat image for the runtime environment
FROM tomcat:9.0-jdk11-openjdk

# Remove default Tomcat apps (including the default ROOT) to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the freshly compiled war file from the builder stage straight into Tomcat's deployment folder as ROOT.war
COPY --from=builder /app/target/parabank.war /usr/local/tomcat/webapps/ROOT.war

# Force database and temp writes to go to /tmp (Render's writable directory) to prevent HSQLDB crashes
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"

EXPOSE 8080
CMD ["catalina.sh", "run"]