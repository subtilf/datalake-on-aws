resource "aws_iam_policy" "this" {
  name        = var.iam_policy_name
  path        = var.iam_policy_path
  description = var.iam_policy_desc
  policy = var.iam_policy_json
}