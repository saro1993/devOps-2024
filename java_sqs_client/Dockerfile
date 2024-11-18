FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package


FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/imagegenerator.jar

ENV SQS_QUEUE_URL=<din_sqs_queue_url>

ENTRYPOINT ["java", "-jar", "/app/imagegenerator.jar"]
