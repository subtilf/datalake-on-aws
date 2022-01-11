locals {
  kms_datalake_name = format("%s-%s-%s-%s", "kms", var.account_name, var.kms_datalake_name, var.environment)
  glue_catalog_name = format("%s-%s-%s-%s", "glue", var.account_name, var.glue_catalog_name, var.environment)
}
