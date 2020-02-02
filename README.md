# CircleCI Dockerfile Wizard

Easily build Docker images with different versions/combinations of common languages/dependencies, for use on CircleCI.

## Prerequisites

- [CircleCI account](https://circleci.com/signup)
- [Docker Hub account](https://hub.docker.com) (Docker itself **does not** need to be installed on your computer)

## Usage

**1. Fork this repository and start building it on CircleCI:**

![Setup Project](https://raw.githubusercontent.com/CircleCI-Public/dockerfile-wizard/master/img/setup%20project.jpg "Setup Project")

**2. Add your Docker Hub username (`DOCKER_USERNAME`) and password (`DOCKER_PASSWORD`) to CircleCI, either as project-specific environment variables (shown below), or as resources in your **org-global** (default) [Context](https://circleci.com/docs/2.0/contexts)**

![Environment Variables](https://raw.githubusercontent.com/CircleCI-Public/dockerfile-wizard/master/img/env%20vars.jpg "Environment Variables")

**3.** Modify Dockerfile and commit and push your changes

**4.** Modify .circleci/config.yml with IMAGE_NAME and IMAGE_TAG

Once the build has finished, your image will be available at `http://hub.docker.com/r/DOCKER_USERNAME/IMAGE_NAME` and can be used in other projects building on CircleCI (or anywhere else!). The Dockerfile for your image will be stored as an artifact in this project's `build` job.

### How it works

CircleCI builds your Docker image from the Dockerfile, deploys it using your Docker credentials.
