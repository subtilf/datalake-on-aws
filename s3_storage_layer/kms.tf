##################################################
## KMS key declaration for all datalake buckets ##
##################################################

module "kms_datalake_key" {
  source   = "git@github.com:subtilf-tf-mod/aws-kms.git"
  kms_desc = "Key used to create all s3 environment related to the Data Lake!"
  tags = {
    name  = local.kms-datalake-name
    env   = var.environment
    owner = var.owner
  }
}
