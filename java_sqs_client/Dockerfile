# Byggesteg - Bygger applikasjonen
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Kjøresteg - Kjør applikasjonen i et minimalt miljø
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar /app/imagegenerator.jar

# Miljøvariabel for SQS Queue URL
ENV SQS_QUEUE_URL=<din_sqs_queue_url>

# Kommando for å kjøre applikasjonen
ENTRYPOINT ["java", "-jar", "/app/imagegenerator.jar"]
