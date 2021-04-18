variable "storage_size" {
  default = 40
}

variable "minor_upgrade" {
  default = true
}

variable "backup_ret_period" {
  default = 7
}

variable "db_subnet_group_name" {
  type = string
}

variable "enabled_cloudwatch_logs_exports" {

}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
  sensitive = true
}

variable "parameter_group_name" {
  type = string
}

variable "password" {
  type = string
  sensitive = true
}

variable "final_snapshot_identifier" {
  type    = string
  default = "rds-final-snapshot"
}

#variable "identifier" {
#  type = string
#}

#variable "kms_key" {
#  type = string
#}

variable "multi_az" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(any)
}

variable "vpc_security_group_ids" {
  type = list(string)
}