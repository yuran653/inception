# Inception - École 42 Project

## Description

Inception is a system administration project that focuses on using Docker to set up a small infrastructure composed of different services. The goal is to virtualize several Docker images in a personal virtual machine.

## Mandatory Part

### Key Requirements:

1. Set up a virtual machine
2. Use Docker Compose to orchestrate the services
3. Create custom Dockerfiles for each service
4. Use Alpine or Debian (penultimate stable version) as base images
5. Implement three main containers:
   - NGINX with TLSv1.2 or TLSv1.3
   - WordPress + php-fpm
   - MariaDB
6. Set up two volumes:
   - WordPress database
   - WordPress website files
7. Establish a docker-network for container communication
8. Ensure containers restart on crash
9. Configure domain name (login.42.fr) to point to local IP
10. Use environment variables for configuration (no passwords in Dockerfiles)
11. Create two WordPress database users (including an administrator)

### Infrastructure Specifications:

- NGINX container as the sole entry point (port 443, TLSv1.2 or TLSv1.3)
- Containers must not use infinite loops or hacky patches
- Volumes mounted in /home/login/data on the host machine
- Use of latest tag is prohibited
- Proper use of environment variables and Docker secrets recommended

## Bonus Part

### Redis Cache

Set up a Redis cache container for the WordPress website to improve performance and manage caching efficiently.

### Adminer

Implement an Adminer container, providing a web-based database management tool for easy interaction with the MariaDB database.

## How to Use

Before running the project, you need to set up your credentials. Follow these steps:

### 1. Create and fill in the following files in the `secrets` directory:

#### db_creds.txt
Fill in the database credentials:

DB_NAME=your_database_name  
DB_USER=your_database_user  
DB_PASS=your_database_password  

#### wp_creds.txt
Fill in the WordPress credentials and settings:

URL=your_wordpress_url  

TITLE=your_site_title  
ADMIN_LOGIN=your_admin_username  
ADMIN_PASS=your_admin_password  
ADMIN_MAIL=your_admin_email  

USER1_LOGIN=your_user1_username  
USER1_PASS=your_user1_password  
USER1_ROLE=your_user1_role  
USER1_MAIL=your_user1_email  

#### db_root_pass.txt
This file should contain only the root password for your database. Create the file and add your desired root password as a single string:

your_root_password  

### 2. After filling in these credentials, you can proceed with building and running your Docker containers using the provided Makefile:

`make` or `make all` - builds and runs the project  
`make up` - runs the project (without rebuilding)  
`make down` -  stops the project  
`make re` - stops the project, rebuilds it, and then runs it again  
`make clean` - deletes volumes and images related to the project, also deletes volumes folders (requires sudo password)  
`make fclean` - deletes volumes and images related to the project, deletes volumes folders (requires sudo password), and clears Docker system cache (unused images, networks, volumes, etc.)

- Wordpress website will be available at `https://localhost`
- Adminer will be available at `http://localhost:8080`
