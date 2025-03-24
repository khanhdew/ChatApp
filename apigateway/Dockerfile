# Create a smaller runtime image
FROM openjdk:17-slim
WORKDIR /app
# Copy only the built JAR file from the build stage
COPY ./target/*.jar app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]