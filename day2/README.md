# 🚀 VProfile Multi-Tier Web Application

A complete multi-tier web application stack deployed using Vagrant and VirtualBox, featuring automated provisioning and configuration management.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Services & Configuration](#services--configuration)
- [Access Information](#access-information)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

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

![alt text](file:///home/mohamed/Pictures/Screenshots/Screenshot%20from%202025-11-24%2017-48-38.png)

---

## 🔧 Prerequisites

Before you begin, ensure you have the following installed:

- **Vagrant** (>= 2.2.0)
- **VirtualBox** (>= 6.1)
- **Git**
- **Minimum 8GB RAM** (recommended for running 4 VMs)
- **20GB free disk space**

### Installation

**macOS:**
```bash
brew install vagrant virtualbox
```

**Ubuntu/Debian:**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant virtualbox
```

**Windows:**
- Download and install from [Vagrant](https://www.vagrantup.com/downloads) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

---

## 🚦 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/abdelrahmanonline4/sourcecodeseniorwr.git
cd sourcecodeseniorwr
```

### 2. Start the Infrastructure

```bash
# Launch all VMs
vagrant up

# Or launch individually
vagrant up nginx
vagrant up tomcat
vagrant up rmq
vagrant up db
```

### 3. Verify Services

```bash
# Check VM status
vagrant status

# SSH into any VM
vagrant ssh nginx
vagrant ssh tomcat
vagrant ssh rmq
vagrant ssh db
```

### 4. Access the Application

Open your browser and navigate to:
```
http://localhost:80
```

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

**Specifications:**
- Apache Tomcat 9.0.75
- OpenJDK 11
- Memory: 512MB min, 1GB max
- Application deployed at `/vprofile-v2/`

**Environment:**
```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
CATALINA_HOME=/opt/tomcat9
```

### 🐰 RabbitMQ (192.168.56.4)

**Purpose:** Message broker for async processing

**Features:**
- Management UI enabled
- Erlang runtime included
- Default ports: 5672 (AMQP), 15672 (Management)

**Access Management UI:**
```
http://192.168.56.4:15672
Username: guest
Password: guest
```

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

### SSH Access

```bash
# Access any VM
vagrant ssh <vm-name>

# Examples:
vagrant ssh nginx
vagrant ssh tomcat
vagrant ssh rmq
vagrant ssh db
```

---

## 🛠️ Troubleshooting

### VMs Not Starting

```bash
# Check VirtualBox status
VBoxManage list runningvms

# Restart a specific VM
vagrant reload <vm-name>

# Destroy and recreate
vagrant destroy <vm-name>
vagrant up <vm-name>
```

### Application Not Accessible

1. **Check Nginx Status:**
```bash
vagrant ssh nginx
sudo systemctl status nginx
```

2. **Check Tomcat Status:**
```bash
vagrant ssh tomcat
sudo systemctl status tomcat
```

3. **Verify Network Connectivity:**
```bash
# From nginx VM
curl http://192.168.56.3:8080/vprofile-v2/
```

### Database Connection Issues

```bash
# SSH into Tomcat VM and check /etc/hosts
vagrant ssh tomcat
cat /etc/hosts | grep db01

# Should show: 192.168.56.5 db01
```

### Port Conflicts

If port 80 is already in use:
```ruby
# Edit Vagrantfile
nginx.vm.network "forwarded_port", guest: 80, host: 8080
```

### View Logs

```bash
# Nginx logs
vagrant ssh nginx
sudo tail -f /var/log/nginx/error.log

# Tomcat logs
vagrant ssh tomcat
sudo tail -f /opt/tomcat9/logs/catalina.out

# MariaDB logs
vagrant ssh db
sudo tail -f /var/log/mysql/error.log
```

---

## 🧹 Management Commands

### Stop All VMs
```bash
vagrant halt
```

### Restart All VMs
```bash
vagrant reload
```

### Destroy All VMs
```bash
vagrant destroy -f
```

### Provision Specific VM
```bash
vagrant provision <vm-name>
```

### Take Snapshots
```bash
vagrant snapshot save <snapshot-name>
vagrant snapshot restore <snapshot-name>
```

---

## 🔐 Security Notes

⚠️ **Important:** This setup is for development/testing purposes only!

- Root database password is hardcoded
- RabbitMQ uses default credentials
- No SSL/TLS encryption
- Remote database access is enabled
- Firewall rules are not configured

**For Production:**
- Use strong, unique passwords
- Enable SSL/TLS encryption
- Configure firewall rules
- Disable root remote access
- Use secrets management (Vault, etc.)
- Enable database encryption
- Implement backup strategies

---

## 📊 Resource Requirements

| VM | CPU | RAM | Disk | OS |
|----|-----|-----|------|----|
| Nginx | 1 core | 512MB | 10GB | Ubuntu 22.04 |
| Tomcat | 2 cores | 2GB | 20GB | Ubuntu 22.04 |
| RabbitMQ | 1 core | 1GB | 10GB | Ubuntu 22.04 |
| MariaDB | 1 core | 1GB | 20GB | Ubuntu 22.04 |
| **Total** | **5 cores** | **4.5GB** | **60GB** | |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📧 Contact & Support

- **Repository:** [GitHub](https://github.com/abdelrahmanonline4/sourcecodeseniorwr)
- **Issues:** [Report Issues](https://github.com/abdelrahmanonline4/sourcecodeseniorwr/issues)

---

## 🎓 Learning Resources

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Apache Tomcat Documentation](https://tomcat.apache.org/tomcat-9.0-doc/)
- [RabbitMQ Tutorials](https://www.rabbitmq.com/tutorials)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

---

**Made with ❤️ for DevOps Learning**
