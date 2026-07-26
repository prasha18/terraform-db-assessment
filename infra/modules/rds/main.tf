resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.env}-postgres"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = "appdb"
  username               = "dbuser"
  password               = "SuperSecretPass123!" # In real production, set via KMS/Secrets Manager
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible    = false
  skip_final_snapshot    = var.env == "dev" ? true : false

  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection

  tags = {
    Environment = var.env
  }
}
