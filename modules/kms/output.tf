output "kms_arn" {
  value = aws_kms_key.this.arn
}

output "kms_key" {
  value = aws_kms_key.this.key_id
}