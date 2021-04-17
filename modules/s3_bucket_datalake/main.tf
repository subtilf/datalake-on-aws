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
  replication_configuration {
    role = var.rc_iam_role_replication

    rules {
      id     = var.rc_rule_id
      priority = var.rc_rule_priority 
      #prefix not declared
      status = var.rc_rule_status

      destination {
        #source_selection_criteria not declared
        bucket        = var.rc_bucket_dest
        storage_class = var.rc_storage_class
        replica_kms_key_id = var.rc_kms_key
      }
      source_selection_criteria{
        sse_kms_encrypted_objects{
          enabled = var.sse_kms_enabled
        }
      }
    }
  }
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