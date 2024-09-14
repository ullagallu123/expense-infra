# Project Name: **Ugl** Security Groups Configuration

## Overview

This project sets up the necessary security groups for various components in an AWS environment, such as bastion, VPN, database, backend, frontend, internal ALB, and external ALB. The security groups are configured to allow specific traffic between different components to ensure secure communication within the environment.

## Modules

The following Terraform modules are used to create security groups:

### 1. Bastion
- **Module Name**: `bastion`
- **Description**: Security Group for the bastion host.
- **Security Group Description**: "This SG was used for bastion."

### 2. VPN
- **Module Name**: `vpn`
- **Description**: Security Group for VPN.
- **Security Group Description**: "This SG was used for vpn."

### 3. Database
- **Module Name**: `db`
- **Description**: Security Group for the database.
- **Security Group Description**: "This SG was used for db."

### 4. Backend
- **Module Name**: `backend`
- **Description**: Security Group for the backend service.
- **Security Group Description**: "This SG was used for backend."

### 5. Frontend
- **Module Name**: `frontend`
- **Description**: Security Group for the frontend service.
- **Security Group Description**: "This SG was used for frontend."

### 6. Internal ALB
- **Module Name**: `internal_alb`
- **Description**: Security Group for the internal application load balancer.
- **Security Group Description**: "This SG was used for internal_alb."

### 7. External ALB
- **Module Name**: `external_alb`
- **Description**: Security Group for the external application load balancer.
- **Security Group Description**: "This SG was used for external_alb."

## Security Group Rules

The following security group rules have been configured:

### Database (`db`)
- **Port 3306**: Ingress allowed from VPN, Bastion, and Backend.

### Bastion (`bastion`)
- **Port 22**: Ingress allowed from the internet (SSH).

### VPN (`vpn`)
- **Port 22**: Ingress allowed from the internet (SSH).
- **Port 443**: Ingress allowed from the internet (HTTPS).
- **Port 943**: Ingress allowed from the internet (TCP).
- **Port 1194**: Ingress allowed from the internet (UDP).

### Backend (`backend`)
- **Port 22**: Ingress allowed from Bastion and VPN (SSH).
- **Port 8080**: Ingress allowed from Bastion, VPN, and Internal ALB (TCP).

### Frontend (`frontend`)
- **Port 22**: Ingress allowed from Bastion and VPN (SSH).
- **Port 80**: Ingress allowed from Bastion, VPN, and External ALB (HTTP).

### Internal ALB (`internal_alb`)
- **Port 80**: Ingress allowed from Bastion, VPN, and Frontend (HTTP).

### External ALB (`external_alb`)
- **Port 80**: Ingress allowed from Bastion, VPN, and the Internet (HTTP).
- **Port 443**: Ingress allowed from the internet (HTTPS).


# AWS Security Groups Configuration

This document describes the configuration of Security Groups and their associated rules for a typical web application architecture. The architecture includes an external ALB, frontend, internal ALB, backend, and a database.

## Security Groups and Rules

### 1. **External ALB Security Group**

- **Description**: Security Group for External Application Load Balancer (ALB).
- **Ingress Rules**:
  - **HTTP (Port 80)**
    - Protocol: `tcp`
    - Source: `0.0.0.0/0` (Internet)
    - Description: Allows HTTP traffic from the internet.
  - **HTTPS (Port 443)**
    - Protocol: `tcp`
    - Source: `0.0.0.0/0` (Internet)
    - Description: Allows HTTPS traffic from the internet.
- **Egress Rules**:
  - **HTTP (Port 80) to Frontend**
    - Protocol: `tcp`
    - Target Security Group: `frontend`
    - Description: Allows HTTP traffic to the Frontend.

### 2. **Frontend Security Group**

- **Description**: Security Group for the Frontend service.
- **Ingress Rules**:
  - **HTTP (Port 80)**
    - Protocol: `tcp`
    - Source Security Group: `external_alb`
    - Description: Allows HTTP traffic from the External ALB.
- **Egress Rules**:
  - **HTTP (Port 80) to Internal ALB**
    - Protocol: `tcp`
    - Target Security Group: `internal_alb`
    - Description: Allows HTTP traffic to the Internal ALB.

### 3. **Internal ALB Security Group**

- **Description**: Security Group for Internal Application Load Balancer (ALB).
- **Ingress Rules**:
  - **HTTP (Port 80)**
    - Protocol: `tcp`
    - Source Security Group: `frontend`
    - Description: Allows HTTP traffic from the Frontend.
- **Egress Rules**:
  - **HTTP (Port 8080) to Backend**
    - Protocol: `tcp`
    - Target Security Group: `backend`
    - Description: Allows traffic to the Backend on port 8080.

### 4. **Backend Security Group**

- **Description**: Security Group for the Backend service.
- **Ingress Rules**:
  - **HTTP (Port 8080)**
    - Protocol: `tcp`
    - Source Security Group: `internal_alb`
    - Description: Allows traffic from the Internal ALB on port 8080.
- **Egress Rules**:
  - **MySQL (Port 3306) to Database**
    - Protocol: `tcp`
    - Target Security Group: `db`
    - Description: Allows traffic to the Database on port 3306.

### 5. **Database Security Group**

- **Description**: Security Group for the Database.
- **Ingress Rules**:
  - **MySQL (Port 3306)**
    - Protocol: `tcp`
    - Source Security Group: `backend`
    - Description: Allows traffic from the Backend on port 3306.

## Notes

- Ensure that the security group rules are carefully managed to restrict access only to the necessary services.
- Security group IDs (e.g., `external_alb`, `frontend`, `internal_alb`, `backend`, `db`) should be replaced with the actual IDs when implementing these configurations.
