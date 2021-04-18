resource "aws_kms_key" "this" {
  description              = var.kms_desc
  key_usage                = var.key_usage
  customer_master_key_spec = var.type_key
  #policy not declared
  #deletion_window_in_days not declared
  #is enabled not declared (default true)
  #enable_key_rotation not declared
  tags = var.tags
}