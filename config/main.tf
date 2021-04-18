provider "aws" {
  region = var.main_region
}

terraform {
  backend "s3" {
    bucket = "s3-sublab-tfstate"
    key    = "datalake/config.tfstate"
    region = "us-east-2"
  }
}

module "s3_config_bucket" {
  source      = "../modules/s3_bucket_versioning"
  bucket_name = "s3-sublab-config-lab"
  tags = {
    name  = "s3-sublab-config-lab"
    env   = "lab"
    owner = "terraform"
  }
}

module "s3_bucket_pub_access_block_airflow" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_config_bucket.bucket_id
}