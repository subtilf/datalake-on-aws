variable "sg_name" {

}

variable "desc" {
  default = "Default EC2 instance description"
}

variable "vpc_id" {

}

variable "tags" {
  type = map(any)
}