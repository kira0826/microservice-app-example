# Phase 1: Defining build phase to compile code. 

FROM maven:3.8.4-openjdk-8-slim AS builder
WORKDIR /app
COPY . .

# Build using the Maven installation in the image
#TODO: Verify why can not use maven wrapper.
RUN mvn clean install

FROM openjdk:8-jre-slim
WORKDIR /app
COPY --from=builder /app/target/users-api-0.0.1-SNAPSHOT.jar /app/users-api.jar
CMD ["java", "-jar", "/app/users-api.jar"]