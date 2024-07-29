# Inventory App

## Overview

This project is an Inventory Management application built using Ballerina, MySQL, and Kubernetes. The application allows you to perform CRUD operations on an inventory database. It includes configuration for deployment using Cloud, Kubernetes, and MySQL.

## Prerequisites

- [Ballerina](https://ballerina.io/) - Programming language
- [MySQL](https://www.mysql.com/) - Database
- [Kubernetes](https://kubernetes.io/) - Container orchestration platform
- [Docker](https://www.docker.com/) - Containerization platform

## Project Structure

1. `main.bal` - Ballerina code defining the service.
2. `Cloud.toml` - Cloud configuration for deployment.
3. `Configs.toml` - Configuration file for database connection.
4. `Secrets.toml` - Secrets for sensitive data like database credentials.
5. `mysql_deployment.yml` - Kubernetes configuration for MySQL deployment.

## Ballerina Code Explanation (`main.bal`)

### Imports

```ballerina
import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
```

- `http`: For HTTP server functionalities.
- `sql`: For SQL operations.
- `mysql`: For MySQL client functionalities.
- `mysql.driver as _`: For hidden MySQL driver operations.

### Type Definition

```ballerina
type Item record {
    int id?;
    string name;
    int quentity;
};
```

Defines a record type `Item` to represent inventory items.

### Configurable Variables

```ballerina
configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string databaseName = ?;
```

Configuration for database connection.

### Service Definition

```ballerina
service /store on new http:Listener(9090) {
    final mysql:Client databaseClient;

    public function init() returns error? {
        self.databaseClient = check new(host, username, password, databaseName, port);
    }
```

Defines a service running on port 9090 with a MySQL client.

#### Resource Functions

- **`get .()`**: Retrieves all items from the inventory.
- **`post .(@http:Payload Item item)`**: Inserts a new item into the inventory.
- **`get liveness()`**: Returns an OK status to check service liveness.
- **`get rediness()`**: Checks readiness by querying the inventory count.

### Cloud Configuration (`Cloud.toml`)

- **Image Repository**: `dinethsiriwardana/invenroty_app:0.1.0`
- **Memory & CPU**: Configures resource limits and autoscaling.
- **Probes**: Configures liveness and readiness probes.

### Configuration Files

- **`Configs.toml`**: Contains database connection details.
- **`Secrets.toml`**: Contains sensitive information like database credentials.

### Kubernetes Deployment (`mysql_deployment.yml`)

1. **Service**: Exposes MySQL service.
2. **Persistent Volume Claims**: For MySQL data and initialization script storage.
3. **Deployment**:
   - **Init Container**: Downloads and sets up the MySQL initialization script.
   - **Main Container**: Runs the MySQL database with the specified configuration.

## CLI Commands

### Build and Run

```bash
# Build Ballerina Project
ballerina build

# Run Ballerina Project
ballerina run main.bal
```

### Kubernetes Deployment

```bash
# Apply Kubernetes Configurations
kubectl apply -f mysql_deployment.yml

# Check MySQL Pods
kubectl get pods

# Check Services
kubectl get svc
```

### Cloud Deployment

```bash
# Deploy to Cloud
cloud deploy --config Cloud.toml
```

## Notes

- Ensure MySQL is accessible at `mysql8-service` on port `3306`.
- Modify configuration files (`Configs.toml`, `Secrets.toml`) as per your environment.
- Update Docker image repository and tag in `Cloud.toml` as needed.
