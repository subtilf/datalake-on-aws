variable "bucket_name" {

}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = map(any)
}

variable "force_destroy" {
  default = "true"
}

#variable "target_log_bucket"{
#    default = "s3-sublab-tfstate"
#}
#
#variable "target_log_prefix"{
#    default = "s3_log_default/"
#}

variable "default_versioning" {
  default = true
}

#Every variable in this module starting with "lcr" is related to the lifecycle rules!
variable "lcr_id" {

}

variable "lcr_enabled" {
  default = true
}

variable "lcr_tags" {
  type = map(any)
}

variable "lcr_exp_days" {
  default = 30
}

#Every variable in this module starting with "rc" is related to the replication configuration!

variable "rc_iam_role_replication" {

}

variable "rc_rule_id" {

}

variable "rc_rule_priority" {
  default = 0
}

variable "rc_rule_status" {
  default = "Enabled"
}

variable "rc_bucket_dest" {

}

variable "rc_storage_class" {
  default = "STANDARD"
}

variable "rc_kms_key" {

}

variable "rc_sse_kms_obj" {
  default = true
}

variable "sse_kms_enabled" {
  default = true
}