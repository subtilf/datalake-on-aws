provider "aws" {
  region = var.main_region
}

terraform {
  backend "s3" {}
}
