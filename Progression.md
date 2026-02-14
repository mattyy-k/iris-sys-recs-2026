# Systems Task Progress Log

This document records the steps, issues encountered, and resolutions while completing the IRIS Systems Recruitment tasks.
(Note that descriptions of screenshots are logged in ScreenshotList.md within the 'screenshots/' directory)

## Stage 1 — Dockerizing Rails

### Objective
Package the Rails application into a Docker container.

### Issue Encountered
During `bundle install`, dependency resolution failed with:

Error Snippet:
'Bundler 2.6.2 is running, but your lockfile was generated with 2.6.6. Installing Bundler 2.6.6 and restarting using that version.
Fetching gem metadata from https://rubygems.org/.
Fetching bundler 2.6.6
Installing bundler 2.6.6
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Could not find compatible versions

Because rails >= 7.0.10, < 7.1.0.beta1 depends on activesupport = 7.0.10
  and Gemfile depends on rails ~> 7.0.10,
  activesupport = 7.0.10 is required.
So, because Gemfile depends on activesupport >= 8.1.2, < 9.A,
  version solving has failed.
The command '/bin/sh -c bundle install' returned a non-zero code: 6'

### Root Cause
Rails 7.0.10 requires activesupport 7.0.10, but the Gemfile explicitly required activesupport >= 8.1.2, causing version incompatibility.

### Resolution
Removed explicit activesupport and activerecord gem entries from the Gemfile and allowed Rails to resolve compatible versions automatically.

### Learning Outcome
Rails manages internal dependency versions, and overriding them can cause dependency solver failures. Docker builds help surface such issues early in a clean environment.
Side Note: Docker currently logs rails process output to stdout/stderr. In the future, docker run -d can be used to run the container in detached mode. This runs the container in the background and frees the terminal.

## Stage 2 — Multi-Container Setup (Rails + MySQL)

### Objective
Run the Rails application and MySQL database in separate Docker containers and enable communication between them using Docker Compose.

### Issue Encountered
Rails failed to connect to MySQL and attempted to use a local UNIX socket:

Error Snippet:
'Can't connect to local server through socket '/var/run/mysqld/mysqld.sock''

### Root Cause
The Rails configuration assumed that MySQL was running on the same machine and attempted to connect via a local socket. However, after containerization, Rails and MySQL were running in separate containers, effectively behaving as separate machines.

### Resolution
Removed socket-based configuration from `database.yml` and configured Rails to connect via TCP:
host: db
port: 3306

Docker Compose service names were used as hostnames, allowing internal DNS resolution.

### Learning Outcome
Containerized services communicate over network interfaces rather than local sockets. "localhost" inside a container refers only to that container itself.

## Stage 3 — Nginx Reverse Proxy

### Objective
Introduce Nginx as a reverse proxy and ensure the Rails application is not directly exposed to the host machine.

### Implementation
- Added an Nginx container.
- Configured Nginx to forward incoming HTTP requests to the Rails service.
- Removed direct port exposure from the Rails container.
- Exposed only Nginx on port 80.

### Architecture
Browser
   ↓
Nginx container
   ↓
Rails container
   ↓
MySQL container
   ↓
Docker volume

### Learning Outcome
Separating the traffic entry point from the application server improves security and allows centralized handling of routing, rate limiting, and load balancing.


## Stage 4 — Multiple Rails Containers and Load Balancing

### Objective
Run multiple instances of the Rails application and distribute incoming requests across them using Nginx.

### Implementation
- Scaled the Rails service using Docker Compose:
docker-compose up --scale web=3
- All Rails containers connected to a single MySQL database.
- Nginx routed requests to the Rails service group.

### Result
Requests were successfully distributed across multiple Rails containers while maintaining a single shared database.

### Learning Outcome
Application servers should remain stateless to enable horizontal scaling. Databases act as the single source of truth and cannot be scaled in the same manner without additional replication mechanisms.

## Stage 5 — Request Rate Limiting using Nginx

### Objective
Limit number of requests per client IP (10r/s) with a burst of 20r/s.

### Implementation
Updated nginx/nginx.conf to account for rate limiting.

### Learning Outcome
Rate must be limited by a single entity who can see and process all incoming traffic; in this case nginx.

## Stage 6 - Visualization of Metrics using Prometheus and Grafana

### Objective
Visualize different metrics such as container memory, 

### Complication:

Prometheus was configured to scrape metrics from cAdvisor and expose them for visualization in Grafana. The monitoring stack was successfully deployed using Docker Compose, and metrics were visualized through Grafana dashboards.

During implementation, it was observed that when running Docker Desktop with WSL, cAdvisor is unable to access container-level cgroup metrics because Docker containers run inside an isolated virtualized environment. As a result, only host-level metrics were available in this setup.

This limitation was investigated and verified through Prometheus queries. The monitoring pipeline itself was confirmed to be functioning correctly. On native Linux hosts, container-level metrics are available without further configuration.

This behaviour and investigation are documented as part of the system design considerations.

## Stage 7 - 
