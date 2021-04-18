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

variable "rc_kms_key" {

}