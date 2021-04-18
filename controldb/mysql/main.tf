provider "aws" {
  region = var.main_region
}

terraform {
    required_version = ">= 0.14"
    backend "s3"{
    bucket = "s3-sublab-tfstate"
    key = "datalake/control_db_mysql.tfstate"
    region = "us-east-2"
  }
}

module "rds_security_group"{
  source = "../../modules/aws_security_group"
  sg_name = "rds-controldb-sg"
  desc = "Security group responsible to allow just connections from VPC to the instance"
  vpc_id = var.vpc_id
  tags = {
    name  = "vpc-sublab-controldb-sg-lab"
    env   = "lab"
    owner = "terraform"
  }
}

module "rds_sg_rule_100"{
  source      = "../../modules/aws_security_group_rule"
  type        = "ingress"
  cidr_blocks = [var.cidr_vpc]
  from_port   = "3306"
  to_port     = "3306"
  protocol    = "tcp"
  sg_id       = module.rds_security_group.sg_id
  desc        = "allow connection from vpc to the db instance"
}

resource "aws_db_subnet_group" "controldb_subnet_group" {
  name       = "s3-sublab-controldb-subnet-gp-lab"
  subnet_ids = var.subnet_list

  tags = {
    name  = "rds-sublab-controldb-subnet-group-lab"
    env   = "lab"
    owner = "terraform"
  }
}

# To store the rds secrets I used the parameter store and configured that manually
# Reference managing secrets in your terraform code: https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1
data "aws_secretsmanager_secret_version" "controldb_creds" {
  secret_id = "dl_control_db_secret"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.controldb_creds.secret_string
  )
}

module "rds_mysql_controldb"{
  source = "../../modules/simple_rds"
  db_subnet_group_name = aws_db_subnet_group.controldb_subnet_group.id
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  engine = "mysql"
  engine_version = "8.0.23"
  db_name = "dl_controldb"
  username = local.db_creds.username
  parameter_group_name = "default.mysql8.0"
  password = local.db_creds.password
  vpc_security_group_ids = [module.rds_security_group.sg_id]
  tags = {
    name  = "rds-sublab-controldb-lab"
    env   = "lab"
    owner = "terraform"
  }
}