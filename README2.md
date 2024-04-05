# Manheim Interview Project

## Table of Contents
1. [Description](#description)
2. [Prerequisites](#prerequisites)
3. [Repository Structure](#repository-structure)
4. [Setup and Configuration](#setup-and-configuration)
5. [CI/CD Pipeline](#ci-cd-pipeline)
6. [Canary Deployment Process](#canary-deployment-process)
7. [Monitoring and Alerts](#monitoring-and-alerts)
8. [Rolling Back Changes](#rolling-back-changes)
9. [Contributing](#contributing)
10. [Contact and Support](#contact-and-support)

## Description
This project consists of a Terraform repository to provision infrastructure, and a basic web application, along with the CI/CD pipelines needed to support these resources. The project is designed to demonstrate best practices in cloud infrastructure management, application deployment, and continuous integration and delivery processes.

## Prerequisites
- AWS account with necessary permissions
- Docker for building and running containers locally
- Terraform for infrastructure provisioning
- Git for version control
- GitHub account for managing CI/CD workflows

## Repository Structure
- `/terraform`: Contains Terraform configurations for AWS infrastructure provisioning.
- `/frontend`: Holds the source code for the front-end application.
- `/backend`: Contains the source code for the back-end application.
- `/.github/workflows`: Stores the GitHub Actions workflows for CI/CD.

## Setup and Configuration
<!-- Details on setting up the local development environment, configuring AWS services, and initializing Terraform for infrastructure management. -->

## CI/CD Pipeline
<!-- Explains the automated processes for testing, building, and deploying the applications and infrastructure across different environments (NP and PR). -->

## Canary Deployment Process
<!-- Outlines the strategy and steps for implementing canary releases, including managing traffic through ALB target group weights and monitoring the deployment's success. -->

## Monitoring and Alerts
<!-- Describes the monitoring setup using CloudWatch, how to configure alerts for system events, and responding to incidents. -->

## Rolling Back Changes
<!-- Instructions on how to rollback application and infrastructure changes in case of deployment issues or other operational failures. -->

## Contact and Support
<!-- Provides contact information and support resources for project maintainers and contributors. -->
