#Stage1
FROM maven:3.8.6-openjdk-8 AS builder

WORKDIR /app

COPY pom.xml ./

RUN mvn dependency:go-offline -B

COPY src src

RUN mvn package -DskipTests

#Stage2
FROM openjdk:8-jdk-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar
COPY wait-for-it.sh .

RUN apk add --no-cache bash && \
    chmod +x ./wait-for-it.sh

EXPOSE 8082

CMD ["./wait-for-it.sh", "postgres:5432", "--", "java", "-jar", "app.jar"]
