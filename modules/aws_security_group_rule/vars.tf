variable "type" {

}

variable "from_port" {

}

variable "to_port" {
  default = 0
}

variable "protocol" {

}

variable "cidr_blocks" {
  type = list(any)
}

variable "sg_id" {

}

variable "desc" {
  default = "Default TF Security Group Description"
}