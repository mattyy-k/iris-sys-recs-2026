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
