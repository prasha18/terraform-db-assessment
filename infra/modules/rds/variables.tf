variable "env" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "rds_sg_id" { type = string }
variable "db_instance_class" { type = string }
variable "backup_retention_period" { type = number }
variable "deletion_protection" { type = bool }
