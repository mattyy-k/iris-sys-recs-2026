# Stage 4 — Multiple Containers and Load Balancing

## Objective
Run multiple instances of the Rails application and distribute incoming requests across them using Nginx.

## Architecture
Multiple Rails containers run simultaneously.
All containers connect to the same MySQL database.
Nginx distributes incoming requests among the Rails instances.

Browser<br>
       ↓
<br>Nginx
       ↓
<br>Rails Container 1
<br>Rails Container 2
<br>Rails Container 3
       ↓
<br>MySQL Container

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

