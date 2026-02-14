# Stage 1 — Dockerizing Rails Application

## Objective
Package the Rails application into a Docker container image and run it as a containerized service.

## Architecture
Rails application runs inside a Docker container using a custom Dockerfile.
The container exposes the Rails server port to the host.

## Steps Followed
- Installed Docker and verified installation.
- Created Dockerfile for Rails application.
- Installed dependencies using Bundler.
- Built Docker image using `docker build`.
- Ran container and verified application accessibility.

## Decisions & Tradeoffs
- Used Docker for environment consistency and reproducibility.
- Containerization avoids dependency issues across systems.

## Challenges Encountered
- Dependency conflicts in Gemfile during bundle install.
- Version mismatch between Rails and activesupport.

## Resolution
Removed explicit dependency overrides and allowed Rails to manage compatible versions.

## Learnings
- Docker images provide reproducible environments.
- Rails dependency resolution is managed through Bundler.

# Stage 2 — MySQL Containerization

## Objective
Run MySQL in a separate Docker container and connect it to the Rails application.

## Architecture
Rails container connects to MySQL container through Docker Compose networking.
Database data is persisted using Docker volumes.

## Steps Followed
- Added MySQL service in docker-compose.yml.
- Configured database.yml to use container hostname.
- Created Docker volume for persistent storage.
- Verified connectivity between Rails and MySQL containers.

## Decisions & Tradeoffs
- Database container isolated from application container.
- Volumes used to ensure data persistence.

## Challenges Encountered
- Initial socket-based connection failed.
- Containers required TCP-based connection using service name.

## Resolution
Updated Rails database configuration to use MySQL container hostname.

## Learnings
- Containers communicate via internal Docker networks.
- Volumes persist data independently of container lifecycle.

# Stage 3 — Nginx Reverse Proxy

## Objective
Introduce an Nginx container to act as a reverse proxy in front of the Rails application.

## Architecture
Incoming requests first reach the Nginx container.
Nginx forwards requests internally to the Rails application container.
The Rails application is no longer directly exposed to the host.

Browser
   ↓
Nginx (Port 80)
   ↓
Rails Container
   ↓
MySQL Container

## Steps Followed
- Added Nginx service in docker-compose.yml.
- Created Nginx configuration file.
- Configured reverse proxy to forward requests to Rails service.
- Exposed Nginx on port 80.
- Removed direct exposure of Rails container port.

## Decisions & Tradeoffs
- Reverse proxy separates traffic handling from application logic.
- Nginx allows future features like load balancing and rate limiting.

## Challenges Encountered
- Understanding container networking and service naming.
- Ensuring internal communication between containers.

## Resolution
Used Docker Compose service names for internal routing.

## Learnings
- Reverse proxies improve security and architecture separation.
- Application containers should not directly handle external traffic.

# Stage 4 — Multiple Containers and Load Balancing

## Objective
Run multiple instances of the Rails application and distribute incoming requests across them using Nginx.

## Architecture
Multiple Rails containers run simultaneously.
All containers connect to the same MySQL database.
Nginx distributes incoming requests among the Rails instances.

Browser
   ↓
Nginx
   ↓
Rails Container 1
Rails Container 2
Rails Container 3
   ↓
MySQL Container

## Steps Followed
- Scaled Rails service using Docker Compose.
- Configured Nginx upstream block.
- Verified requests were handled by different containers.
- Ensured all containers used a single database.

## Decisions & Tradeoffs
- Horizontal scaling improves availability and concurrency.
- Shared database ensures data consistency.

## Challenges Encountered
- Understanding how Nginx routes requests.
- Ensuring all application containers connect correctly to the database.

## Resolution
Configured upstream servers in Nginx and verified container connectivity.

## Learnings
- Stateless application containers enable horizontal scaling.
- Load balancing improves reliability and performance.

# Stage 5 — Monitoring with Prometheus and Grafana

## Objective
Configure a monitoring solution to collect and visualize system and container metrics.

## Architecture
Prometheus scrapes metrics from exporters and stores time-series data.
Grafana connects to Prometheus to visualize metrics.

Prometheus
   ↓
Exporter (cAdvisor)
   ↓
Grafana Dashboard

## Steps Followed
- Added Prometheus and Grafana services using Docker Compose.
- Configured Prometheus scrape targets.
- Connected Grafana to Prometheus as a data source.
- Imported dashboards and created custom panels.

## Decisions & Tradeoffs
- Prometheus chosen for time-series monitoring.
- Grafana used for visualization and dashboarding.

## Challenges Encountered
- Container-level metrics were not visible when running Docker Desktop with WSL.
- cAdvisor was able to access host-level metrics but not Docker container cgroups.

## Resolution
Investigation revealed that Docker Desktop runs containers inside an isolated virtual machine, preventing cAdvisor from accessing container-level metrics from within WSL.
The monitoring pipeline itself was verified to be functioning correctly through Prometheus queries.

## Learnings
- Monitoring visibility depends on runtime environment.
- Exporters must run in the same kernel context as monitored containers.
- Observability systems must be designed with infrastructure boundaries in mind.

---

## Alternative Monitoring Approach (Netdata)

During implementation, an alternative monitoring approach using Netdata was also evaluated.

### Motivation
While Prometheus and Grafana successfully formed a monitoring pipeline, it was observed that when running Docker Desktop with WSL, container-level metrics exposed through cAdvisor were limited due to Docker Desktop operating containers inside an isolated virtual machine. This restricted visibility into container cgroups from within the WSL environment.

To validate monitoring behaviour independently of exporter limitations, Netdata was introduced as an additional monitoring tool.

### Approach
Netdata was deployed as a single container and configured to collect system-level metrics automatically without requiring explicit exporters or metric queries.

### Observations
- Netdata provided immediate visualization of system metrics without additional configuration.
- Monitoring worked reliably within the Docker Desktop + WSL environment.
- This demonstrated that the monitoring pipeline itself was functional, and that earlier limitations were related to exporter visibility rather than system misconfiguration.

### Learnings
- Different monitoring tools operate at different layers of abstraction.
- Exporter-based monitoring (Prometheus) provides flexibility and scalability.
- Integrated monitoring tools (Netdata) provide faster setup and immediate observability.
- Tool selection depends on deployment environment and monitoring requirements.
