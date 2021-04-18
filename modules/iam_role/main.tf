resource "aws_iam_role" "this" {
  name               = var.iam_role_name
  assume_role_policy = var.iam_role_policy

  tags = var.tags
}