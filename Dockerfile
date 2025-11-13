FROM dp-harbor.zhito.com/temurin/eclipse-temurin:23.0.2_7-jdk-ubi9-minimal

WORKDIR /app

COPY . /app

RUN ./mvnw clean package -DskipTests

EXPOSE 9002

CMD ["java", "-jar", "target/demo-proj-0.0.1-SNAPSHOT.jar"]
