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
