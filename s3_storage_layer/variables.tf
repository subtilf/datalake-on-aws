variable "main_region" {
  type        = string
  default     = "us-east-2"
  description = "Variable used to set the main region for backend execution"
}

variable "secondary_region" {
  type        = string
  default     = "us-east-1"
  description = "Variable used to set the secondary region for backend execution"
}

variable "account_name" {
  type        = string
  description = "Variable used to set the AWS account name to be used by modules, locals and resources"
}

variable "environment" {
  type        = string
  description = "Variable used to set the enviroment to terraform be applied. I recommend to use lab, dev, qa and prod"
}

variable "kms-datalake-name" {
  type        = string
  description = "Variable used to set the name of KMS key responsible to encrypt all datalake buckets"
}

variable "policy-bucket-actions" {
  type        = list(any)
  description = "Variable used the set all actions of datalake bucket's to be configured into a policy"
}

variable "policy-bucket-object-actions" {
  type        = list(any)
  description = "Variable used the set all actions of datalake bucket object's to be configured into a policy"
}

variable "dl_first_layer_name" {
  type        = string
  description = "Variable used to set the name of the datalake's first layer"
}

variable "dl_second_layer_name" {
  type        = string
  description = "Variable used to set the name of the datalake's second layer"
}

variable "dl_third_layer_name" {
  type        = string
  description = "Variable used to set the name of the datalake's third layer"
}

variable "owner" {
  type        = string
  description = "Variable used to set the name of the team or user responsible for the implementation"
}