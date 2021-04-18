variable "main_region" {
  default = "us-east-2"
}

variable "secondary_region" {
  default = "us-east-1"
}

variable "subnet_list"{
 type = list(string)
}

variable "vpc_id"{
 type = string
}

variable "cidr_vpc"{
 type = string
}