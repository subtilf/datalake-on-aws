output "kms_key" {
  value = module.kms_datalake_key.kms_key
}

output "kms_arn" {
  value = module.kms_datalake_key.kms_arn
}
