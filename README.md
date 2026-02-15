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
