locals {
  rds-controldb-sg = format("%s%s%s", var.rds-controldb-sg, "-", var.environment)
  controldb-subnet-group-name = format("%s%s%s", var.controldb-subnet-group-name, "-", var.environment)
  identifier = format("%s%s%s", var.identifier, "-", var.environment)
}