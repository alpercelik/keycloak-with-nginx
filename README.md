# Keycloak Docker Setup

This repository provides a Dockerized setup for Keycloak, a powerful open-source identity and access management solution. The setup includes Nginx as a reverse proxy to handle HTTPS requests and manage traffic to the Keycloak instance. This project is designed to simplify the deployment of Keycloak in a development or production environment, allowing for easy configuration and management of user authentication and authorization.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Project Structure

```
.
├── Dockerfile              # Defines the custom Keycloak image
├── docker-compose.yml      # Defines the service stack
├── nginx.conf             # Nginx reverse proxy configuration
├── config.sh              # Shared configuration variables
├── build.sh              # Script to build the Keycloak image
├── run.sh                # Script to run the entire setup
├── gen-certs.sh          # Script to generate SSL certificates
├── certs/                # Directory for SSL certificates
└── themes/               # Directory for custom Keycloak themes
```

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Generate SSL Certificates**:
   ```bash
   ./gen-certs.sh
   ```

3. **Build the Keycloak Image**:
   ```bash
   ./build.sh
   ```

4. **Start the Services**:
   ```bash
   ./run.sh
   ```

## Usage

### Accessing Keycloak
- URL: `https://localhost` (or your custom hostname)
- Default Admin Credentials:
  - Username: `admin`
  - Password: `admin`

### Custom Hostname
To use a custom hostname:
```bash
./run.sh your-custom-hostname
```

## Configuration

### Environment Variables
The following environment variables can be configured in `docker-compose.yml`:
- `KEYCLOAK_ADMIN`: Admin username
- `KEYCLOAK_ADMIN_PASSWORD`: Admin password
- `KC_DB_*`: Database connection settings
- `KC_HOSTNAME_URL`: Public URL for Keycloak

### SSL Certificates
- Self-signed certificates are generated automatically
- For production, replace the certificates in `certs/` with your own SSL certificates

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.