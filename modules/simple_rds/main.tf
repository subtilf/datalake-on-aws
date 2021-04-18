resource "aws_db_instance" "this" {
  allocated_storage = var.storage_size
  # allow_major_version_upgrade not declared
  # apply_immediately not declared
  auto_minor_version_upgrade = var.minor_upgrade
  # availability_zone not declared
  backup_retention_period = var.backup_ret_period
  # backup_window not declared
  # ca_cert_identifier not declared
  # character_set_name not declared
  # copy_tags_to_snapshot not declared
  db_subnet_group_name = var.db_subnet_group_name
  # delete_automated_backups not declared
  # deletion_protection not declared
  # domain not declared
  # domain_iam_role_name not declared
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  engine                          = var.engine
  engine_version                  = var.engine_version
  final_snapshot_identifier       = var.final_snapshot_identifier
  # iam_database_authentication_enabled not declared
  # identifier not declared
  # identifier_prefix not declared
  instance_class = var.instance_class
  # iops not declared
  # kms_key_id = var.kms_key
  # license_model not declared
  # maintenance_window not declared
  # max_allocated_storage not declared
  # monitoring_interval not declared
  # monitoring_role_arn not declared
  multi_az = var.multi_az
  name     = var.db_name
  # option_group_name not declared
  parameter_group_name = var.parameter_group_name
  password             = var.password
  # performance_insights_enabled not declared
  # performance_insights_kms_key_id not declared
  # performance_insights_retention_period not declared
  # port not declared
  # publicly_accessible not declared
  # replicate_source_db not declared
  # restore_to_point_in_time not declared
  # s3_import not declared
  # security_group_names not declared
  skip_final_snapshot = var.skip_final_snapshot
  # snapshot_identifier not declared
  username = var.username
  # storage_encrypted not declared
  # storage_type not declared
  tags = var.tags
  # timezone not declared
  vpc_security_group_ids = var.vpc_security_group_ids
}