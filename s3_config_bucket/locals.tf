locals {
  bucket_name = format("%s-%s-%s-%s", "s3", var.account_name, var.bucket_name, var.environment)
}
