module "kms_datalake_glue_catalog_key" {
  source   = "git@github.com:subtilf-tf-mod/aws-kms.git"
  kms_desc = "Key used to encrypt all glue catalog"
  tags = {
    name  = local.kms_datalake_name
    env   = var.environment
    owner = var.owner
  }
}
