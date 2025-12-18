FROM eclipse-temurin:21-jdk
#FROM --platform=linux/amd64 eclipse-temurin:21-jdk
RUN apt-get update && apt-get install -y maven

WORKDIR /app

COPY . /app

RUN mvn clean package

COPY target/tgmeng-api-v1.0.2.jar /app/my-app.jar

RUN mkdir -p /app/data/subscritions/
RUN mkdir -p /app/data/history/

EXPOSE 4399
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -XX:+AlwaysPreTouch -Djava.security.egd=file:/dev/./urandom"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar my-app.jar"]