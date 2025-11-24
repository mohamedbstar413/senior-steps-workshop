# 🚀 VProfile Multi-Tier Web Application

A complete multi-tier web application stack deployed using Vagrant and VirtualBox, featuring automated provisioning and configuration management.

---

## 🎯 Overview

VProfile is a production-ready multi-tier web application that demonstrates modern DevOps practices and infrastructure automation. The project uses Vagrant to simulate provisioning a complete on-premise application stack with separate VMs for each service layer.

### Key Features

✅ **Automated Infrastructure** - Complete VM provisioning with Vagrant
✅ **Automated Configuration** - Complete Shell Script for each VM  
✅ **Multi-Tier Architecture** - Separated concerns across 4 VMs  
✅ **Reverse Proxy** - Nginx for load balancing and routing  
✅ **Message Queue** - RabbitMQ for async processing  
✅ **Database Layer** - MariaDB with pre-populated data  

---

## 🏗️ Architecture
<img width="581" height="591" alt="Screenshot from 2025-11-24 17-48-38" src="https://github.com/user-attachments/assets/b03d8824-6c3a-4252-be81-85f73619fed0" />
---
## Runtime
<img width="1913" height="924" alt="image" src="https://github.com/user-attachments/assets/d10c3d24-80e6-4008-9b8d-f14f922157d2" />

---

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

- **Vagrant** (>= 2.2.0)
- **VirtualBox** (>= 6.1)
- **Git**
- **Minimum 8GB RAM** (recommended for running 4 VMs)
- **20GB free disk space**
---
## 📁 Project Structure

```
.
├── Vagrantfile           # VM orchestration configuration
├── nginx.sh              # Nginx provisioning script
├── tomcat.sh             # Tomcat + Java application setup
├── rabbitmq.sh           # RabbitMQ installation & config
├── mariadb.sh            # Database setup with seed data
└── README.md             # This file
```

---

## ⚙️ Services & Configuration

### 🌐 Nginx (192.168.56.2)

**Purpose:** Reverse proxy and web server

**Configuration:**
- Listens on port 80
- Proxies requests to Tomcat backend
- Context path rewriting for `/vprofile-v2/`

**Key Features:**
- Load balancing ready
- Header forwarding for real IP tracking
- SSL termination ready

### ☕ Tomcat (192.168.56.3)

**Purpose:** Java application server




### 🐰 RabbitMQ (192.168.56.4)

**Purpose:** Message broker for async processing

**Features:**
- Management UI enabled
- Erlang runtime included
- Default ports: 5672 (AMQP), 15672 (Management)



### 🗄️ MariaDB (192.168.56.5)

**Purpose:** Relational database server

**Database Details:**
- Database: `accounts`
- Root password: `admin123`
- Remote access enabled

**Pre-populated Tables:**
- `user` - User accounts with hashed passwords
- `role` - User roles
- `user_role` - User-role mapping

**Connection String:**
```
Host: 192.168.56.5
Database: accounts
Username: root
Password: vprodbpass
```

---

## 🔑 Access Information

### Application Access

| Service | URL | Credentials |
|---------|-----|-------------|
| **Web App** | http://localhost:80 | See pre-populated users |
| **Tomcat Direct** | http://192.168.56.3:8080/vprofile-v2/ | N/A |
| **RabbitMQ UI** | http://192.168.56.4:15672 | guest / guest |
| **MariaDB** | 192.168.56.5:3306 | root / vprodbpass |

### Pre-configured Users

| Username | Email | Password (hashed) |
|----------|-------|-------------------|
| admin_vp | admin@hkhinfo.com | (bcrypt) |
| Abrar Nirban | abrar.nirban74@gmail.com | (bcrypt) |
| Amayra Fatima | amayra@gmail.com | (bcrypt) |

*Note: All passwords are bcrypt-hashed in the database*

---

