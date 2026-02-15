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
