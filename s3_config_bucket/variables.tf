variable "main_region" {
  type        = string
  description = "Variable used to set the main region for backend execution"
}

variable "account_name" {
  type        = string
  description = "Variable used to set the AWS account name to be used by modules, locals and resources"
}

variable "environment" {
  type        = string
  description = "Variable used to set the enviroment to terraform be applied. I recommend to use lab, dev, qa and prod"
}

variable "bucket_name" {
  type        = string
  description = "Variable used to set the name of the bucket"
}

variable "owner" {
  type        = string
  description = "Variable used to set the name of the team or user responsible for the implementation"
}
