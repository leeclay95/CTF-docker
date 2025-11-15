# CTF-docker
CTF built to test basic  privilege escalation 



## 📋 Prerequisites

You need Docker and Docker Compose installed on your system:

### **Ubuntu/Debian:**

# Install Docker
sudo apt update
sudo apt install -y docker.io docker-compose


### **Verify Installation:**

docker --version
docker-compose --version

### 1. Clone the Repository

### 2. Build and Start the Container
docker-compose up -d --build
This will:
- Download the Ubuntu 20.04 base image
- Install Apache, PHP, and SSH services
- Configure the vulnerable web application
- Set up user accounts and privilege escalation vectors
- Start all services automatically

# Check container status
docker ps

# View logs
docker logs ctf-vulnerable-box

# Test web application
curl http://localhost:8080/ping.php

