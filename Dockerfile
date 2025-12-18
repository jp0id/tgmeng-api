# 构建阶段
FROM eclipse-temurin:21-jdk as builder
#FROM --platform=linux/amd64 eclipse-temurin:21-jdk as builder
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

# 运行阶段
FROM eclipse-temurin:21-jre
WORKDIR /app

# 从构建阶段复制JAR文件
COPY --from=builder /app/target/tgmeng-api-v1.0.2.jar /app/my-app.jar

RUN mkdir -p /app/data/subscriptions/ /app/data/history/

EXPOSE 4399
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError -XX:+AlwaysPreTouch -Djava.security.egd=file:/dev/./urandom"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar my-app.jar"]