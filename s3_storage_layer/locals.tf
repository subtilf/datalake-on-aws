locals{
 kms-datalake-name = format("%s-%s", var.kms-datalake-name, var.environment)
 raw-iam-role-name = format("%s-%s-%s-%s", "iam-role", var.account_name, var.raw_bucket_name, var.environment)
 raw-iam-policy-name = format("%s-%s-%s-%s", "iam-policy", var.account_name, var.raw_bucket_name, var.environment)
 raw-iam-policy-desc = format("%s %s", "Policy the container all rules for the replication works for", var.raw_bucket_name)
 raw-bucket-name = format("%s-%s-%s-%s", "s3", var.account_name, var.raw_bucket_name, var.environment)
 raw-rep-bucket-name = format("%s-%s-%s-%s-%s", "s3", var.account_name, var.raw_bucket_name, "rep", var.environment)
 raw-lcr-id = format("%s-%s-%s-%s", "s3", var.account_name, var.raw_bucket_name, "lcr-rule")
 raw-lcr-rep-id = format("%s-%s-%s-%s", "s3", var.account_name, var.raw_bucket_name, "rep-lcr-rule")
 raw-rc-id = format("%s-%s-%s-%s", "s3", var.account_name, var.raw_bucket_name, "rc-rule")
 raw-resources-list = [
 module.s3_raw_layer.bucket_arn,
 format("%s/%s", module.s3_raw_layer.bucket_arn, "*"),
 module.s3_raw_layer_rep.bucket_arn,
 format("%s/%s", module.s3_raw_layer_rep.bucket_arn, "*")
 ]
  standard-iam-role-name = format("%s-%s-%s-%s", "iam-role", var.account_name, var.standard_bucket_name, var.environment)
 standard-iam-policy-name = format("%s-%s-%s-%s", "iam-policy", var.account_name, var.standard_bucket_name, var.environment)
 standard-iam-policy-desc = format("%s %s", "Policy the container all rules for the replication works for", var.standard_bucket_name)
 standard-bucket-name = format("%s-%s-%s-%s", "s3", var.account_name, var.standard_bucket_name, var.environment)
 standard-rep-bucket-name = format("%s-%s-%s-%s-%s", "s3", var.account_name, var.standard_bucket_name, "rep", var.environment)
 standard-lcr-id = format("%s-%s-%s-%s", "s3", var.account_name, var.standard_bucket_name, "lcr-rule")
 standard-lcr-rep-id = format("%s-%s-%s-%s", "s3", var.account_name, var.standard_bucket_name, "rep-lcr-rule")
 standard-rc-id = format("%s-%s-%s-%s", "s3", var.account_name, var.standard_bucket_name, "rc-rule")
 standard-resources-list = [
 module.s3_standard_layer.bucket_arn,
 format("%s/%s", module.s3_standard_layer.bucket_arn, "*"),
 module.s3_standard_layer_rep.bucket_arn,
 format("%s/%s", module.s3_standard_layer_rep.bucket_arn, "*")
 ]
 creation-iam-role-name = format("%s-%s-%s-%s", "iam-role", var.account_name, var.creation_bucket_name, var.environment)
 creation-iam-policy-name = format("%s-%s-%s-%s", "iam-policy", var.account_name, var.creation_bucket_name, var.environment)
 creation-iam-policy-desc = format("%s %s", "Policy the container all rules for the replication works for", var.creation_bucket_name)
 creation-bucket-name = format("%s-%s-%s-%s", "s3", var.account_name, var.creation_bucket_name, var.environment)
 creation-rep-bucket-name = format("%s-%s-%s-%s-%s", "s3", var.account_name, var.creation_bucket_name, "rep", var.environment)
 creation-lcr-id = format("%s-%s-%s-%s", "s3", var.account_name, var.creation_bucket_name, "lcr-rule")
 creation-lcr-rep-id = format("%s-%s-%s-%s", "s3", var.account_name, var.creation_bucket_name, "rep-lcr-rule")
 creation-rc-id = format("%s-%s-%s-%s", "s3", var.account_name, var.creation_bucket_name, "rc-rule")
 creation-resources-list = [
 module.s3_creation_layer.bucket_arn,
 format("%s/%s", module.s3_creation_layer.bucket_arn, "*"),
 module.s3_creation_layer_rep.bucket_arn,
 format("%s/%s", module.s3_creation_layer_rep.bucket_arn, "*")
 ]
}
