locals {
  kms-datalake-name     = format("%s-%s", var.kms-datalake-name, var.environment)
  first-iam-role-name   = format("%s-%s-%s-%s", "iam-role", var.account_name, var.dl_first_layer_name, var.environment)
  first-iam-policy-name = format("%s-%s-%s-%s", "iam-policy", var.account_name, var.dl_first_layer_name, var.environment)
  first-iam-policy-desc = format("%s %s", "Policy the container all rules for the replication works for", var.dl_first_layer_name)
  first-bucket-name     = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_first_layer_name, var.environment)
  first-rep-bucket-name = format("%s-%s-%s-%s-%s", "s3", var.account_name, var.dl_first_layer_name, "rep", var.environment)
  first-lcr-id          = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_first_layer_name, "lcr-rule")
  first-lcr-rep-id      = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_first_layer_name, "rep-lcr-rule")
  first-rc-id           = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_first_layer_name, "rc-rule")
  first-resources-list = [
    module.s3_first_layer.bucket_arn,
    format("%s/%s", module.s3_first_layer.bucket_arn, "*"),
    module.s3_first_layer_rep.bucket_arn,
    format("%s/%s", module.s3_first_layer_rep.bucket_arn, "*")
  ]
  second-iam-role-name   = format("%s-%s-%s-%s", "iam-role", var.account_name, var.dl_second_layer_name, var.environment)
  second-iam-policy-name = format("%s-%s-%s-%s", "iam-policy", var.account_name, var.dl_second_layer_name, var.environment)
  second-iam-policy-desc = format("%s %s", "Policy the container all rules for the replication works for", var.dl_second_layer_name)
  second-bucket-name     = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_second_layer_name, var.environment)
  second-rep-bucket-name = format("%s-%s-%s-%s-%s", "s3", var.account_name, var.dl_second_layer_name, "rep", var.environment)
  second-lcr-id          = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_second_layer_name, "lcr-rule")
  second-lcr-rep-id      = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_second_layer_name, "rep-lcr-rule")
  second-rc-id           = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_second_layer_name, "rc-rule")
  second-resources-list = [
    module.s3_second_layer.bucket_arn,
    format("%s/%s", module.s3_second_layer.bucket_arn, "*"),
    module.s3_second_layer_rep.bucket_arn,
    format("%s/%s", module.s3_second_layer_rep.bucket_arn, "*")
  ]
  third-iam-role-name   = format("%s-%s-%s-%s", "iam-role", var.account_name, var.dl_third_layer_name, var.environment)
  third-iam-policy-name = format("%s-%s-%s-%s", "iam-policy", var.account_name, var.dl_third_layer_name, var.environment)
  third-iam-policy-desc = format("%s %s", "Policy the container all rules for the replication works for", var.dl_third_layer_name)
  third-bucket-name     = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_third_layer_name, var.environment)
  third-rep-bucket-name = format("%s-%s-%s-%s-%s", "s3", var.account_name, var.dl_third_layer_name, "rep", var.environment)
  third-lcr-id          = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_third_layer_name, "lcr-rule")
  third-lcr-rep-id      = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_third_layer_name, "rep-lcr-rule")
  third-rc-id           = format("%s-%s-%s-%s", "s3", var.account_name, var.dl_third_layer_name, "rc-rule")
  third-resources-list = [
    module.s3_third_layer.bucket_arn,
    format("%s/%s", module.s3_third_layer.bucket_arn, "*"),
    module.s3_third_layer_rep.bucket_arn,
    format("%s/%s", module.s3_third_layer_rep.bucket_arn, "*")
  ]
}
