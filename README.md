# Blockscout ARM64/V8 Image Builder

This project provides a Makefile to automate the process of building Docker images for the Blockscout backend and frontend components, specifically targeting the ARM64/v8 architecture (compatible with Apple Silicon, such as M1 and M2 chips). It also pushes these images to a personal Docker Hub repository (`0x6572696b`).

## Overview

The Makefile clones the official Blockscout backend and frontend GitHub repositories, checks out the specified versions, builds Docker images for ARM64/v8 using `docker buildx`, and pushes them to a personal Docker Hub repository. This is particularly helpful for deploying Blockscout on ARM64-based systems, such as Apple Silicon (M1, M2, M3 and M4).

## Prerequisites

To use this project, ensure you have the following tools installed:

- **Docker**: Must include Buildx support for multi-architecture image building. Ensure Buildx is configured (e.g., with the `docker-container` driver).
- **Make**: The utility to run the Makefile.
- **Git**: Required to clone the Blockscout repositories.
- Access to push images to the Docker Hub repository specified in the Makefile (or modify it to use your own repository).

## Usage

Follow these steps to build and push the Docker images:

1. **Log in to Docker Hub:**

   ```sh
   docker login
   ```

2. **Build and push both the backend and frontend images:**

   ```sh
   make all
   ```

   This command will:
   - Build the backend image for ARM64/v8.
   - Build the frontend image for ARM64/v8.
   - Push both images to the specified Docker Hub repository.

   If you only want to build the images without pushing them:

   ```sh
   make build-all
   ```

   To push already built images:

   ```sh
   make push-all
   ```

   You can also work with individual components:
   - Build backend: `make backend`
   - Build frontend: `make frontend`
   - Push backend: `make push-backend`
   - Push frontend: `make push-frontend`

## Configuration

### Versions

The versions for the backend and frontend are defined in the Makefile:
- Backend: `BLOCKSCOUT_BACKEND_VERSION:=7.0.0`
- Frontend: `BLOCKSCOUT_FRONTEND_VERSION:=1.37.6`

To update versions, either edit the Makefile directly or override them when running the command:

```sh
make all DOCKER_USERNAME=foobar BLOCKSCOUT_BACKEND_VERSION=7.1.0 BLOCKSCOUT_FRONTEND_VERSION=1.38.0
```

### Docker Hub Repository

The images are pushed to `0x6572696b/blockscout-backend` and `0x6572696b/blockscout-frontend`. To use a different repository, update the `DOCKER_USERNAME` variable or modify the `push-backend` and `push-frontend` targets in the Makefile.

### Building for ARM64/v8

The Makefile uses `docker buildx build` to create ARM64/v8 images. This ensures compatibility with ARM64 systems, including Apple Silicon (M1, M2 chips). If needed, you can explicitly specify the platform in the Makefile:

```makefile
docker buildx build --platform linux/arm64/v8 -f ./docker/Dockerfile -t blockscout/blockscout:v$(BLOCKSCOUT_BACKEND_VERSION) .
```

Apply the same logic for the frontend if necessary.

## Notes

- Ensure the specified versions exist in the Blockscout repositories before building.
- After pushing, verify the images by pulling them from Docker Hub and testing on an ARM64/v8 system, such as an Apple Silicon Mac:
  - Pull backend: `docker pull 0x6572696b/blockscout_backend:v7.0.0`
  - Pull frontend: `docker pull 0x6572696b/blockscout_frontend:v1.37.6`
- This project is ideal for deploying Blockscout on ARM64/v8 hardware, especially Apple Silicon.
- If you edit the Makefile, double-check repository names and versions for accuracy.