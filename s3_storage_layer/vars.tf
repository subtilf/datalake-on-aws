variable "main_region" {
  type = string
  default = "us-east-2"
}

variable "secondary_region" {
  type = string
  default = "us-east-1"
}

variable "account_name" {
  type = string
}

variable "environment"{
  type = string
}

variable "kms-datalake-name"{
  type = string
}

variable "policy-bucket-actions"{
  type = list
}

variable "policy-bucket-object-actions"{
  type = list
}

variable "raw_bucket_name"{
  type = string
}

variable "standard_bucket_name"{
  type = string
}

variable "creation_bucket_name"{
  type = string
}