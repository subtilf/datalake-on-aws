resource "aws_glue_catalog_database" "aws_glue_datalake_catalog" {
  name        = local.glue_catalog_name
  description = "Database responsible for store all metadata relationed to each layer of datalake."
}

resource "aws_glue_data_catalog_encryption_settings" "aws_glue_data_catalog_encryption" {
  data_catalog_encryption_settings {
    connection_password_encryption {
      aws_kms_key_id                       = module.kms_datalake_glue_catalog_key.kms_arn
      return_connection_password_encrypted = true
    }

    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
      sse_aws_kms_key_id      = module.kms_datalake_glue_catalog_key.kms_arn
    }
  }
  depends_on = [aws_glue_catalog_database.aws_glue_datalake_catalog]
}
