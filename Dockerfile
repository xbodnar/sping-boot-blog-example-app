FROM gradle:7.6-jdk11 AS build

WORKDIR /app

# Copy gradle files
COPY build.gradle ./
COPY gradle* ./
COPY gradlew* ./

# Download dependencies
RUN gradle dependencies --no-daemon || true

# Copy source code
COPY src ./src

# Build the application
RUN gradle bootJar --no-daemon

FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]