# n8n Project with Evolution API

[Español](Readme.md) | **English**

This project integrates **n8n** (workflow automation tool), **Evolution API** (WhatsApp API), and **ngrok** (secure tunnels) using Docker to create a complete messaging automation environment.

## 🚀 Features

- ✅ Workflow automation with n8n
- ✅ WhatsApp integration through Evolution API
- ✅ Secure service exposure with ngrok
- ✅ Complete containerization with Docker
- ✅ Data persistence with Docker volumes
- ✅ Production-ready configuration

## 📋 Prerequisites

- Docker and Docker Compose installed
- ngrok account (for public exposure)
- Port 5678 available (n8n)
- Port 8080 available (Evolution API)

## 🛠️ Installation and Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd <project-name>
```

### 2. Configure Evolution API

**⚠️ IMPORTANT**: The `evolution-api/` folder has its own independent configuration.

```bash
cd evolution-api/
# Follow the instructions in the README.md inside this folder
# Configure its docker-compose.yml according to its specifications
cd ..
```

### 3. Configure main project environment variables

Copy the example file and configure your variables:

```bash
cp .env.example .env
```

Edit the `.env` file with your specific configurations.

### 4. Start the services

```bash
# FIRST: Start Evolution API (from its folder)
cd evolution-api/
docker-compose up -d
cd ..

# SECOND: Start n8n and other services
docker-compose up -d

# View logs of all services
docker-compose logs -f

# View logs of a specific service (example: n8n)
docker-compose logs -f n8n
```

## 📁 Project Structure

```
.
├── evolution-api/          # ⚠️ INDEPENDENT FOLDER with its own README.md and docker-compose.yml
│   ├── README.md          # ← FOLLOW THESE INSTRUCTIONS FIRST
│   ├── docker-compose.yml # ← Independent Evolution API configuration
│   └── ...                # Other Evolution API files
├── docker-compose.yml      # Docker services configuration (n8n, ngrok, etc.)
├── Dockerfile             # Custom image (if applicable)
├── entrypoint.sh          # Initialization script
├── .env.example           # Environment variables template
├── .gitignore            # Files to ignore in Git
└── README.md             # This file (Spanish version)
```

## 🔧 Included Services

### n8n (Port 5678)
- **Description**: Workflow automation platform
- **Local access**: http://localhost:5678
- **Volume**: `n8n_data:/home/node/.n8n` (data persistence)

### Evolution API (Port 8080)
- **Description**: API for WhatsApp integration
- **Local access**: http://localhost:8080
- **Documentation**: Available at `/docs`
- **⚠️ Special configuration**: The `evolution-api/` folder contains its own README.md and docker-compose.yml. **Follow the specific instructions in its README** before continuing.

### ngrok
- **Description**: Secure tunnels for public exposure
- **Configuration**: Automatic for n8n and Evolution API

## 📡 Useful Commands

### Docker Compose

```bash
# IMPORTANT: Evolution API has its own commands
# For Evolution API, run from evolution-api/:
cd evolution-api/
docker-compose up -d        # Start Evolution API
docker-compose down         # Stop Evolution API
docker-compose logs -f      # View Evolution API logs
cd ..

# For n8n and other services (from project root):
docker-compose up -d        # Start main services
docker-compose down         # Stop main services
docker-compose restart n8n  # Restart n8n
docker-compose ps          # View main services status
docker-compose logs -f     # View main services logs

# Access n8n container
docker-compose exec n8n bash
```

### Data Management

```bash
# Backup n8n volume
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n_backup.tar.gz -C /data .

# Restore backup
docker run --rm -v n8n_data:/data -v $(pwd):/backup alpine tar xzf /backup/n8n_backup.tar.gz -C /data
```

## 🔗 Access URLs

- **n8n Local**: http://localhost:5678
- **Evolution API Local**: http://localhost:8080
- **n8n Public**: Obtained from ngrok after startup
- **Evolution API Public**: Obtained from ngrok after startup

## 🛡️ Security

- Use environment variables for sensitive credentials
- ngrok provides HTTPS automatically
- Consider using basic authentication in n8n for production
- Keep Docker images updated

## 📊 Monitoring

### View specific logs
```bash
# n8n logs
docker-compose logs -f n8n

# Evolution API logs
docker-compose logs -f evolution-api

# ngrok logs
docker-compose logs -f ngrok
```

### Service status
```bash
# View active services
docker-compose ps

# Check resource usage
docker stats
```

## 🔄 Backup and Restoration

### Recommended backup

Regular backups of the `n8n_data` volume are recommended as it contains all developed workflows and configurations.

```bash
# Create backup
./scripts/backup.sh

# Restore backup
./scripts/restore.sh backup_file.tar.gz
```

## 🐛 Troubleshooting

### Common issues

1. **Port occupied**: Verify that ports 5678 and 8080 are available
2. **Volume permissions**: Ensure Docker has write permissions
3. **Environment variables**: Verify that the `.env` file is correctly configured

### Debug logs
```bash
# View all logs
docker-compose logs

# Logs with timestamp
docker-compose logs -t

# Last 100 lines
docker-compose logs --tail=100
```

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is under the MIT License. See the `LICENSE` file for more details.

## 🆘 Support

If you encounter any problems or have questions:

1. Check [existing issues](../../issues)
2. Create a new issue if necessary
3. Provide relevant logs and detailed problem description

---

**Note**: This project is for development and testing. For production, consider implementing additional security and monitoring measures.