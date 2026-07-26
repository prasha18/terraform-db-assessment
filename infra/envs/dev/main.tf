terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source               = "../../modules/network"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "ecs" {
  source             = "../../modules/ecs"
  env                = var.env
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  alb_sg_id          = module.network.alb_sg_id
  ecs_sg_id          = module.network.ecs_sg_id
  container_cpu      = var.container_cpu
  container_memory   = var.container_memory
}

module "rds" {
  source                  = "../../modules/rds"
  env                     = var.env
  private_subnet_ids      = module.network.private_subnet_ids
  rds_sg_id               = module.network.rds_sg_id
  db_instance_class       = var.db_instance_class
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
}
