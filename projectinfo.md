## Overview

This page provides overview of proposed solution for scenario described in [README](README.md).

Main folders of project Insight Dashboard are:

### app 

This folder contains application source code. I have used a sample Angular application available from https://github.com/start-angular/SB-Admin-BS4-Angular-6.
Folder also contains configuration files for running unit tests. Dockerfile to contaiinerize application and Jenkinsfile to represent CI/CD pipeline as code (PaC).
Though team has not yet decided on CI/CD tool, I have quickly structured a sample Jenkinsfile depciting typical steps in a pipeline that will allow Continuous Deployment with appopriate "Gates". 

### automation

This folder contains code and configuration for automating maintenance of infrastructure for application deployment as well as tools such as Jenkins and ECR for development teams. [Terraform AWS modules](https://github.com/terraform-aws-modules) are used to setup VPC, EKS cluster and nodes for application deployment. In similar manner CI/CD tools required for the project i.e. Jenkins master and agents, ECR (Amazon Elastic Container Registry) can be maintained using Terraform scripts (For this assignment they were created manually).

### scripts

This folder contains scripts and instructions for team to execute manually before fully atutomating the deployment.

Following tools will be required on personal workstation or CI/CD tool to deploy application.

- Git & Git Bash (https://tortoisegit.org/)
- Node JS version > 10 (https://nodejs.org/dist/v10.16.0/node-v10.16.0-x64.msi)
- aws cli (https://aws.amazon.com/cli/)
- kubectl (https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- aws-iam-authenticator (https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- terraform (https://www.terraform.io/downloads.html)

Follow steps listed below to build, package and deploy application to AWS.

A. Project Setup

- Create a project folder. 
```
mkdir projects
```
- Clone this GitHub Repo in the project folder
```
cd projects
git clone https://github.com/jm-cxhr/re-hiring-project.git
```
