provider "aws" {
  region = var.main_region
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket = "s3-sublab-tfstate"
    key    = "datalake/glue_catalog.tfstate"
    region = "us-east-2"
  }
}

module "kms_datalake_glue_catalog_key" {
  source   = "../modules/kms"
  kms_desc = "Key used to encrypt all glue catalog"
  tags = {
    name  = local.kms-datalake-name
    env   = "lab"
    owner = "terraform"
  }
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database_raw" {
  name        = local.aws-glue-catalog-name
  description = "Database responsible for store all metadata relationed to each layer of datalake."
}

resource "aws_glue_data_catalog_encryption_settings" "aws_glue_data_catalog_encryption" {
  data_catalog_encryption_settings {
    connection_password_encryption {
      aws_kms_key_id                       = module.kms_datalake_glue_catalog_key.kms_arn
      return_connection_password_encrypted = true
    }

    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
      sse_aws_kms_key_id      = module.kms_datalake_glue_catalog_key.kms_arn
    }
  }
}