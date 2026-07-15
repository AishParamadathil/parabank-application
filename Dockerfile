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

# Copy the compiled war file keeping its name 'parabank.war'
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/parabank.war

# Create a default ROOT index that redirects root traffic (/) to /parabank/
RUN mkdir /usr/local/tomcat/webapps/ROOT && \
    echo '<% response.sendRedirect("/parabank/"); %>' > /usr/local/tomcat/webapps/ROOT/index.jsp

# Direct Tomcat's database and temp systems to use /tmp (fully writeable on Render)
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp -Duser.home=/tmp"

# ONLY expose Tomcat's web port so Render's port detection behaves
EXPOSE 8080

CMD ["catalina.sh", "run"]