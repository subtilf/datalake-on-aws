###### Doc reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#lifecycle_rule ####

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl = var.acl
  #Grant not declared
  #Policy not declared
  tags = var.tags
  force_destroy = var.force_destroy
  #Website not declared
  #cors_rule not declared
  versioning {
    enabled = var.default_versioning
  }
  #logging {
  #  target_bucket = var.target_log_bucket
  #  target_prefix = var.target_log_prefix
  #}
  lifecycle_rule {
    id      = var.lcr_id
    enabled = var.lcr_enabled

    #prefix not declared

    tags = var.lcr_tags

    expiration {
      days = var.lcr_exp_days
    } 
  }
  #acceleration_status not declared
  #request_payer not declared
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.rc_kms_key
        sse_algorithm     = "aws:kms"
      }
    }
  }
  #object_lock_configuration not declared 
}