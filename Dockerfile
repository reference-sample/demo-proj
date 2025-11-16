######### 1) Build Stage #########
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# 1. 只复制 pom.xml
COPY pom.xml .

# 2. 预下载依赖（大幅提升构建速度）
RUN mvn -B -q dependency:go-offline

# 3. 再复制源码
COPY src ./src

# 4. 构建项目
RUN mvn -q clean package -DskipTests


######### 2) Runtime Stage #########
FROM eclipse-temurin:21-jre

RUN apt-get update && apt-get install -y --no-install-recommends \
    dnsutils \
    net-tools \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 只复制构建后的产物，不复制多余文件
COPY --from=builder /app/target/demo-proj-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 9002

CMD ["java", "-jar", "app.jar"]
