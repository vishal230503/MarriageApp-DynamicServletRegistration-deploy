# MarriageApp – Dynamic Servlet Registration (deployment-ready layout)

## Folder structure
```
MarriageApp-DynamicServletRegistration/
├── pom.xml                      Maven build -> target/MarriageApp.war
├── Dockerfile                   Multi-stage build -> Tomcat 9 image (ROOT.war)
├── docker-compose.yml           Local run: http://localhost:8080
├── buildspec.yml                AWS CodeBuild -> WAR bundle for CodeDeploy (EC2)
├── buildspec-docker.yml         AWS CodeBuild -> Docker image to ECR (ECS/EKS)
├── appspec.yml                  AWS CodeDeploy lifecycle hooks
├── Jenkinsfile                  Jenkins pipeline
├── .github/workflows/ci-cd.yml  GitHub Actions pipeline (OIDC, no AWS keys)
├── scripts/                     CodeDeploy hook scripts (stop/backup/deploy/start/validate)
└── src/
    ├── main/java/com/nt/
    │   ├── initializer/         MyWebApplicaitonInitializer.java
    │   └── servlet/             MarriageServlet.java
    ├── main/resources/
    ├── main/webapp/
    │   ├── index.html
    │   └── WEB-INF/lib/dyna.jar
    └── test/java/
```

## Move your existing files (Eclipse -> Maven layout)
| Old (Eclipse)                     | New                                    |
|-----------------------------------|----------------------------------------|
| `src/`                            | `src/main/java/`                       |
| `WebContent/index.html`           | `src/main/webapp/index.html`           |
| `WebContent/WEB-INF/lib/dyna.jar` | `src/main/webapp/WEB-INF/lib/dyna.jar` |
| `build/`, `.settings/`, `.classpath`, `.project` | **delete** (generated, git-ignored) |

## Build & run locally
```bash
mvn clean package
docker compose up --build        # http://localhost:8080
```

## AWS options
**A. EC2 + Tomcat (CodeBuild + CodeDeploy)**
1. EC2 with Tomcat 9 as systemd service `tomcat` (edit `scripts/env.sh` if paths differ), CodeDeploy agent installed.
2. Instance role: S3 read + CodeDeploy; open port 8080 (or put an ALB in front, health path `/MarriageApp/`).
3. CodeBuild project uses `buildspec.yml`; CodePipeline: Source -> Build -> CodeDeploy.

**B. Containers (ECR + ECS Fargate / App Runner)**
1. Create an ECR repo; CodeBuild project uses `buildspec-docker.yml` (env: `AWS_ACCOUNT_ID`, `AWS_DEFAULT_REGION`, `ECR_REPO`).
2. ECS service container port 8080, ALB health check path `/`.

Edit the placeholders (`your-artifact-bucket`, region, app/group names) in `Jenkinsfile` and `ci-cd.yml`.

## Assumptions to verify
- `javax.servlet.*` imports + Servlet 3.0+ -> Tomcat 9, Java 8 source level (set `java.version` in `pom.xml`).
  If your code imports `jakarta.servlet.*`, use `jakarta.servlet-api` 5.0.0 and `tomcat:10.1`.
- No `web.xml` (dynamic registration). If you have one, put it in `src/main/webapp/WEB-INF/`.
