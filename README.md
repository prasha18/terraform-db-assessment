# Terraform + Database Reliability Assessment

## Overview

This repository contains the implementation for the Terraform + Database Reliability Assessment.

The project includes:

- Terraform Infrastructure as Code (IaC)
- Modular Terraform design
- Multi-environment support (Dev & Prod)
- AWS Infrastructure provisioning
- PostgreSQL database setup
- Database backup & restore scripts
- Query optimization
- GitHub Actions CI for Terraform

---

# Technologies

- Terraform
- AWS
- Docker
- Docker Compose
- PostgreSQL
- GitHub Actions

---

# Repository Structure

```
terraform-db-assessment/
│
├── database/
│   ├── indexes.sql
│   ├── migrations/
│   └── seeds/
│
├── infra/
│   ├── envs/
│   │   ├── dev/
│   │   └── prod/
│   │
│   └── modules/
│       ├── ecs/
│       ├── network/
│       └── rds/
│
├── scripts/
│   ├── backup.sh
│   ├── restore.sh
│   └── database/
│       └── backups/
│
├── screenshots/
│
├── docker-compose.yml
│
└── README.md
```

---

# Infrastructure

Terraform provisions the following AWS resources.

### Network

- VPC
- Internet Gateway
- Public Subnets
- Private Subnets
- Route Tables
- Route Table Associations
- Security Groups

### ECS

- ECS Cluster
- ECS Task Definition
- ECS Service
- IAM Execution Role

### Database

- PostgreSQL RDS
- DB Subnet Group

---

# Terraform

Terraform uses reusable modules.

```
infra/modules/
```

Modules:

- network
- ecs
- rds

Environments:

```
infra/envs/dev
infra/envs/prod
```

---

# Terraform Commands

Initialize Terraform

```bash
cd infra/envs/dev

terraform init
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan
```

Apply

```bash
terraform apply
```

Destroy

```bash
terraform destroy
```

---

# GitHub Actions

A GitHub Actions workflow is included.

The workflow automatically runs on every Pull Request and performs:

- terraform fmt
- terraform init
- terraform validate
- terraform plan

The Terraform execution plan is uploaded as a GitHub Actions workflow artifact.

---

# Database

Start PostgreSQL

```bash
docker compose up -d
```

Apply migrations

```bash
psql -U postgres -d hoteldb -f database/migrations/001_create_tables.sql
```

Load seed data

```bash
psql -U postgres -d hoteldb -f database/seeds/seed.sql
```

---

# Database Backup

Create a backup

```bash
./scripts/backup.sh
```

Backups are stored in:

```
scripts/database/backups/
```

Example

```
hoteldb_20260726_122532.sql
```

---

# Database Restore

Restore a backup

```bash
./scripts/restore.sh database/backups/hoteldb_20260726_122532.sql
```

---

# Verify Restore

Connect to PostgreSQL

```bash
psql -h localhost -U postgres -d hoteldb_restore
```

Verify the data

```sql
SELECT COUNT(*) FROM hotel_bookings;

SELECT COUNT(*) FROM booking_events;
```

---

# Query Optimization

Original query

```sql
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

Composite index

```sql
CREATE INDEX idx_hotel_bookings_city_created
ON hotel_bookings(city, created_at);
```

## Why this index?

The index is designed based on the query pattern.

- `city` is used as an equality filter.
- `created_at` is used as a range filter.
- PostgreSQL can efficiently narrow the search space before performing the aggregation.

For very small datasets PostgreSQL may still choose a sequential scan because it is cheaper. As the dataset grows, the composite index significantly improves query performance.

---

# Screenshots

The `screenshots/` directory contains screenshots demonstrating:

- Docker containers
- Database backup
- Database restore
- Terraform execution
- GitHub Actions workflow

---

# Author

**Prashanth**

AWS Cloud / DevOps Engineer
