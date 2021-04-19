locals {
  kms-datalake-name = format("%s%s%s", var.kms-datalake-name, "-", var.environment)
  aws-glue-catalog-name = format("%s%s%s", var.aws-glue-catalog-name, "-", var.environment)
}