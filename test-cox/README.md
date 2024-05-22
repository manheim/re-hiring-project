To create a web-based "Hello World" visualization tool and deploy it using a deployment pipeline, we'll use Docker for containerization and AWS for deployment. We'll also use Terraform to manage infrastructure as code and Git for version control. This solution will be generic and scalable to multiple environments (e.g., dev and prod).

Here's a step-by-step guide and the necessary code to accomplish this:

Set Up Your Project Structure

Create a directory for your project.
Initialize a Git repository.
Create a Simple "Hello World" Web Application

We'll use a simple Python Flask application for this purpose.
Dockerize the Application

Create a Dockerfile to containerize the Flask app.
Use Terraform for Infrastructure Management

Write Terraform scripts to deploy the Docker container to AWS ECS.
Set Up Deployment Scripts

Write shell scripts to handle deployment and teardown processes.
Version Control with Git

Commit all changes to the Git repository.