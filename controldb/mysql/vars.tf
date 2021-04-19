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

variable "rds-controldb-sg"{
  type = string
  default = "rds-controldb-sg"
}

variable "environment"{
  type = string
}

variable "controldb-subnet-group-name"{
  type = string
}

variable "secret_id"{
  type = string
  sensitive = true
}

variable "identifier"{
  type = string
}