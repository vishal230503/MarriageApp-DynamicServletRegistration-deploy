# ---------- Stage 1: build ----------
FROM maven:3.9-eclipse-temurin-11 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ---------- Stage 2: runtime ----------
FROM tomcat:9.0-jdk11-temurin
RUN rm -rf /usr/local/tomcat/webapps/* \
 && addgroup --system app && adduser --system --ingroup app app
COPY --from=build /build/target/MarriageApp.war /usr/local/tomcat/webapps/ROOT.war
RUN chown -R app:app /usr/local/tomcat
USER app
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD curl -fs http://localhost:8080/ || exit 1
CMD ["catalina.sh", "run"]
