#############################
## Policy for first bucket ##
#############################

module "iam_role_s3_first_layer" {
  source        = "git@github.com:subtilf-tf-mod/aws-iam-role.git"
  iam_role_name = local.first-iam-role-name
  tags = {
    name  = local.first-iam-role-name
    env   = var.environment
    owner = var.owner
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_first" {
  statement {
    actions   = var.policy-bucket-actions
    effect    = "Allow"
    resources = local.first-resources-list
  }
  statement {
    actions = var.policy-bucket-object-actions
    effect  = "Allow"
    condition {
      test     = "StringLikeIfExists"
      values   = ["aws:kms", "AES256"]
      variable = "s3:x-amz-server-side-encryption"
    }
    condition {
      test     = "StringLikeIfExists"
      values   = [module.kms_datalake_key.kms_arn]
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
    resources = local.first-resources-list
  }
  statement {
    actions = [
      "kms:Decrypt"
    ]
    effect = "Allow"
    condition {
      test     = "StringLike"
      values   = ["s3.us-east-2.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringLike"
      values   = [format("%s%s", module.s3_first_layer.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
  statement {
    actions = [
      "kms:Encrypt"
    ]
    effect = "Allow"
    condition {
      test     = "StringLike"
      values   = ["s3.us-east-2.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringLike"
      values   = [format("%s%s", module.s3_first_layer_rep.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
}

module "iam_policy_s3_first_layer" {
  source          = "git@github.com:subtilf-tf-mod/aws-iam-policy.git"
  iam_policy_name = local.first-iam-policy-name
  iam_policy_desc = local.first-iam-policy-desc
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_first.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_first_layer" {
  role       = module.iam_role_s3_first_layer.role_name
  policy_arn = module.iam_policy_s3_first_layer.policy_arn
}

##############################
## first bucket configuration ##
##############################

module "s3_first_layer" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-datalake.git"
  bucket_name = local.first-bucket-name
  tags = {
    name  = local.first-bucket-name
    env   = var.environment
    owner = var.owner
  }
  lcr_id = local.first-lcr-id
  lcr_tags = {
    name  = local.first-lcr-id
    env   = var.environment
    owner = var.owner
  }
  rc_iam_role_replication = module.iam_role_s3_first_layer.role_arn
  rc_rule_id              = local.first-rc-id
  rc_bucket_dest          = module.s3_first_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_first" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_first_layer.bucket_id
}

module "s3_first_layer_rep" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-datalake-replica.git"
  bucket_name = local.first-rep-bucket-name
  tags = {
    name  = local.first-rep-bucket-name
    env   = var.environment
    owner = var.owner
  }
  lcr_id = local.first-lcr-rep-id
  lcr_tags = {
    name  = local.first-lcr-rep-id
    env   = var.environment
    owner = var.owner
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_first_rep" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_first_layer_rep.bucket_id
}

################################
## Policy for second bucket ##
################################

module "iam_role_s3_second_layer" {
  source        = "git@github.com:subtilf-tf-mod/aws-iam-role.git"
  iam_role_name = local.second-iam-role-name
  tags = {
    name  = local.second-iam-role-name
    env   = var.environment
    owner = var.owner
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_second" {
  statement {
    actions   = var.policy-bucket-actions
    effect    = "Allow"
    resources = local.second-resources-list
  }
  statement {
    actions = var.policy-bucket-object-actions
    effect  = "Allow"
    condition {
      test     = "StringLikeIfExists"
      values   = ["aws:kms", "AES256"]
      variable = "s3:x-amz-server-side-encryption"
    }
    condition {
      test     = "StringLikeIfExists"
      values   = [module.kms_datalake_key.kms_arn]
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
    resources = local.second-resources-list
  }
  statement {
    actions = [
      "kms:Decrypt"
    ]
    effect = "Allow"
    condition {
      test     = "StringLike"
      values   = ["s3.us-east-2.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringLike"
      values   = [format("%s%s", module.s3_second_layer.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
  statement {
    actions = [
      "kms:Encrypt"
    ]
    effect = "Allow"
    condition {
      test     = "StringLike"
      values   = ["s3.us-east-2.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringLike"
      values   = [format("%s%s", module.s3_second_layer_rep.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
}

module "iam_policy_s3_second_layer" {
  source          = "git@github.com:subtilf-tf-mod/aws-iam-policy.git"
  iam_policy_name = local.second-iam-policy-name
  iam_policy_desc = local.second-iam-policy-desc
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_second.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_second_layer" {
  role       = module.iam_role_s3_second_layer.role_name
  policy_arn = module.iam_policy_s3_second_layer.policy_arn
}

###################################
## second bucket configuration ##
###################################

module "s3_second_layer" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-datalake.git"
  bucket_name = local.second-bucket-name
  tags = {
    name  = local.second-bucket-name
    env   = var.environment
    owner = var.owner
  }
  lcr_id = local.second-lcr-id
  lcr_tags = {
    name  = local.second-lcr-id
    env   = var.environment
    owner = var.owner
  }
  rc_iam_role_replication = module.iam_role_s3_second_layer.role_arn
  rc_rule_id              = local.second-rc-id
  rc_bucket_dest          = module.s3_second_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_second" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_second_layer.bucket_id
}

module "s3_second_layer_rep" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-datalake-replica.git"
  bucket_name = local.second-rep-bucket-name
  tags = {
    name  = local.second-rep-bucket-name
    env   = var.environment
    owner = var.owner
  }
  lcr_id = local.second-lcr-rep-id
  lcr_tags = {
    name  = local.second-lcr-rep-id
    env   = var.environment
    owner = var.owner
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_second_rep" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_second_layer_rep.bucket_id
}

################################
## Policy for third bucket ##
################################

module "iam_role_s3_third_layer" {
  source        = "git@github.com:subtilf-tf-mod/aws-iam-role.git"
  iam_role_name = local.third-iam-role-name
  tags = {
    name  = local.third-iam-role-name
    env   = var.environment
    owner = var.owner
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_third" {
  statement {
    actions   = var.policy-bucket-actions
    effect    = "Allow"
    resources = local.third-resources-list
  }
  statement {
    actions = var.policy-bucket-object-actions
    effect  = "Allow"
    condition {
      test     = "StringLikeIfExists"
      values   = ["aws:kms", "AES256"]
      variable = "s3:x-amz-server-side-encryption"
    }
    condition {
      test     = "StringLikeIfExists"
      values   = [module.kms_datalake_key.kms_arn]
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
    resources = local.third-resources-list
  }
  statement {
    actions = [
      "kms:Decrypt"
    ]
    effect = "Allow"
    condition {
      test     = "StringLike"
      values   = ["s3.us-east-2.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringLike"
      values   = [format("%s%s", module.s3_third_layer.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
  statement {
    actions = [
      "kms:Encrypt"
    ]
    effect = "Allow"
    condition {
      test     = "StringLike"
      values   = ["s3.us-east-2.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test     = "StringLike"
      values   = [format("%s%s", module.s3_third_layer_rep.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
}

module "iam_policy_s3_third_layer" {
  source          = "git@github.com:subtilf-tf-mod/aws-iam-policy.git"
  iam_policy_name = local.third-iam-policy-name
  iam_policy_desc = local.third-iam-policy-desc
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_third.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_third_layer" {
  role       = module.iam_role_s3_third_layer.role_name
  policy_arn = module.iam_policy_s3_third_layer.policy_arn
}

###################################
## third bucket configuration ##
###################################

module "s3_third_layer" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-datalake.git"
  bucket_name = local.third-bucket-name
  tags = {
    name  = local.third-bucket-name
    env   = var.environment
    owner = var.owner
  }
  lcr_id = local.third-lcr-id
  lcr_tags = {
    name  = local.third-lcr-id
    env   = var.environment
    owner = var.owner
  }
  rc_iam_role_replication = module.iam_role_s3_third_layer.role_arn
  rc_rule_id              = local.third-rc-id
  rc_bucket_dest          = module.s3_third_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_third" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_third_layer.bucket_id
}

module "s3_third_layer_rep" {
  source      = "git@github.com:subtilf-tf-mod/aws-s3-datalake-replica.git"
  bucket_name = local.third-rep-bucket-name
  tags = {
    name  = local.third-rep-bucket-name
    env   = var.environment
    owner = var.owner
  }
  lcr_id = local.third-lcr-rep-id
  lcr_tags = {
    name  = local.third-lcr-rep-id
    env   = var.environment
    owner = var.owner
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_third_rep" {
  source    = "git@github.com:subtilf-tf-mod/aws-s3-pub-access-block.git"
  BUCKET_ID = module.s3_third_layer_rep.bucket_id
}
