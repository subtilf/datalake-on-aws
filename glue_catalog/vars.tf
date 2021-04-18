variable "main_region" {
  default = "us-east-2"
}

variable "main_vpc" {
  default = "vpc-0a39577fd48d8bf37"
}

variable "cidr_subnet_dmz" {
  default = "172.50.0.0/28"
}

variable "cidr_subnet_p1" {
  default = "172.50.1.0/27"
}

variable "cidr_subnet_p2" {
  default = "172.50.2.0/27"
}

variable "cidr_subnet_p3" {
  default = "172.50.3.0/27"
}

variable "cidr_vpc" {
  default = "172.50.0.0/22"
}

variable "cidr_internet" {
  default = "0.0.0.0/0"
}