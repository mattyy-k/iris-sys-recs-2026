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

