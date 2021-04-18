resource "aws_s3_bucket_public_access_block" "this" {
  bucket = var.BUCKET_ID

  block_public_acls   = var.BLOCK_PUB_ACL
  block_public_policy = var.BLOCK_PUB_POLICY
  ignore_public_acls = var.IGN_PUB_ACLS
  restrict_public_buckets = var.REST_PUB_BUCKETS
}