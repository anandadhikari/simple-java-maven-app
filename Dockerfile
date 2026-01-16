# We use a tiny Linux image with Java 17 installed to run the app
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file built by Jenkins into the container
# Note: The JAR name matches the one in your pom.xml (my-app-1.0-SNAPSHOT.jar)
COPY target/my-app-1.0-SNAPSHOT.jar app.jar

# The command to run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
