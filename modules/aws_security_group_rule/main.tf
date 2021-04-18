resource "aws_security_group_rule" "this" {
  type              = var.type
  cidr_blocks       = var.cidr_blocks
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  security_group_id = var.sg_id
  description       = var.desc
}