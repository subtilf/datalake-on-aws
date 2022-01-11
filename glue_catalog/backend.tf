provider "aws" {
  region = var.main_region
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {}
}
