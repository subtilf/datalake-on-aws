variable "bucket_name" {

}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = map(any)
}

variable "force_destroy" {
  default = "false"
}

variable "default_versioning" {
  default = true
}