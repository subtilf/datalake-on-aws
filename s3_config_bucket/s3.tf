module "s3_config_bucket" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-versioning.git"
  bucket_name = local.bucket_name
  tags = {
    name  = local.bucket_name
    env   = var.environment
    owner = var.owner
  }
}

module "s3_bucket_pub_access_block" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_config_bucket.bucket_id
}
