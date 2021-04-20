provider "aws" {
  region = var.main_region
}

terraform {
  backend "s3" {
    bucket = "s3-sublab-tfstate"
    key    = "datalake/s3_layer.tfstate"
    region = "us-east-2"
  }
}

##################################################
## KMS key declaration for all datalake buckets ##
##################################################

module "kms_datalake_key" {
  source   = "../modules/kms"
  kms_desc = "Key used to create all s3 environment related to the Data Lake!"
  tags = {
    name  = local.kms-datalake-name
    env   = var.environment
    owner = "terraform"
  }
}

###########################
## Policy for raw bucket ##
###########################

module "iam_role_s3_raw_layer" {
  source        = "../modules/iam_role"
  iam_role_name = local.raw-iam-role-name
  tags = {
    name  = local.raw-iam-role-name
    env   = var.environment
    owner = "terraform"
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_raw" {
  statement {
    actions = var.policy-bucket-actions
    effect = "Allow"
    resources = local.raw-resources-list
  }
  statement {
    actions = var.policy-bucket-object-actions
    effect = "Allow"
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
    resources = local.raw-resources-list
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
      values   = [format("%s%s", module.s3_raw_layer.bucket_arn, "/*")]
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
      values   = [format("%s%s", module.s3_raw_layer_rep.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
}

module "iam_policy_s3_raw_layer" {
  source          = "../modules/iam_policy"
  iam_policy_name = local.raw-iam-policy-name
  iam_policy_desc = local.raw-iam-policy-desc
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_raw.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_raw_layer" {
  role       = module.iam_role_s3_raw_layer.role_name
  policy_arn = module.iam_policy_s3_raw_layer.policy_arn
}

##############################
## Raw bucket configuration ##
##############################

module "s3_raw_layer" {
  source      = "../modules/s3_bucket_datalake"
  bucket_name = local.raw-bucket-name
  tags = {
    name  = local.raw-bucket-name
    env   = var.environment
    owner = "terraform"
  }
  lcr_id = local.raw-lcr-id
  lcr_tags = {
    name  = local.raw-lcr-id
    env   = var.environment
    owner = "terraform"
  }
  rc_iam_role_replication = module.iam_role_s3_raw_layer.role_arn
  rc_rule_id              = local.raw-rc-id
  rc_bucket_dest          = module.s3_raw_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_raw" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_raw_layer.bucket_id
}

module "s3_raw_layer_rep" {
  source      = "../modules/s3_bucket_datalake_rep"
  bucket_name = local.raw-rep-bucket-name
  tags = {
    name  = local.raw-rep-bucket-name
    env   = var.environment
    owner = "terraform"
  }
  lcr_id = local.raw-lcr-rep-id
  lcr_tags = {
    name  = local.raw-lcr-rep-id
    env   = var.environment
    owner = "terraform"
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_raw_rep" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_raw_layer_rep.bucket_id
}

################################
## Policy for standard bucket ##
################################

module "iam_role_s3_standard_layer" {
  source        = "../modules/iam_role"
  iam_role_name = local.standard-iam-role-name
  tags = {
    name  = local.standard-iam-role-name
    env   = var.environment
    owner = "terraform"
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_standard" {
  statement {
    actions = var.policy-bucket-actions
    effect = "Allow"
    resources = local.standard-resources-list
  }
  statement {
    actions = var.policy-bucket-object-actions
    effect = "Allow"
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
    resources = local.standard-resources-list
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
      values   = [format("%s%s", module.s3_standard_layer.bucket_arn, "/*")]
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
      values   = [format("%s%s", module.s3_standard_layer_rep.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
}

module "iam_policy_s3_standard_layer" {
  source          = "../modules/iam_policy"
  iam_policy_name = local.standard-iam-policy-name
  iam_policy_desc = local.standard-iam-policy-desc
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_standard.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_standard_layer" {
  role       = module.iam_role_s3_standard_layer.role_name
  policy_arn = module.iam_policy_s3_standard_layer.policy_arn
}

###################################
## standard bucket configuration ##
###################################

module "s3_standard_layer" {
  source      = "../modules/s3_bucket_datalake"
  bucket_name = local.standard-bucket-name
  tags = {
    name  = local.standard-bucket-name
    env   = var.environment
    owner = "terraform"
  }
  lcr_id = local.standard-lcr-id
  lcr_tags = {
    name  = local.standard-lcr-id
    env   = var.environment
    owner = "terraform"
  }
  rc_iam_role_replication = module.iam_role_s3_standard_layer.role_arn
  rc_rule_id              = local.standard-rc-id
  rc_bucket_dest          = module.s3_standard_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_standard" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_standard_layer.bucket_id
}

module "s3_standard_layer_rep" {
  source      = "../modules/s3_bucket_datalake_rep"
  bucket_name = local.standard-rep-bucket-name
  tags = {
    name  = local.standard-rep-bucket-name
    env   = var.environment
    owner = "terraform"
  }
  lcr_id = local.standard-lcr-rep-id
  lcr_tags = {
    name  = local.standard-lcr-rep-id
    env   = var.environment
    owner = "terraform"
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_standard_rep" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_standard_layer_rep.bucket_id
}

################################
## Policy for creation bucket ##
################################

module "iam_role_s3_creation_layer" {
  source        = "../modules/iam_role"
  iam_role_name = local.creation-iam-role-name
  tags = {
    name  = local.creation-iam-role-name
    env   = var.environment
    owner = "terraform"
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_creation" {
  statement {
    actions = var.policy-bucket-actions
    effect = "Allow"
    resources = local.creation-resources-list
  }
  statement {
    actions = var.policy-bucket-object-actions
    effect = "Allow"
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
    resources = local.creation-resources-list
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
      values   = [format("%s%s", module.s3_creation_layer.bucket_arn, "/*")]
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
      values   = [format("%s%s", module.s3_creation_layer_rep.bucket_arn, "/*")]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
    resources = [
      module.kms_datalake_key.kms_arn
    ]
  }
}

module "iam_policy_s3_creation_layer" {
  source          = "../modules/iam_policy"
  iam_policy_name = local.creation-iam-policy-name
  iam_policy_desc = local.creation-iam-policy-desc
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_creation.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_creation_layer" {
  role       = module.iam_role_s3_creation_layer.role_name
  policy_arn = module.iam_policy_s3_creation_layer.policy_arn
}

###################################
## creation bucket configuration ##
###################################

module "s3_creation_layer" {
  source      = "../modules/s3_bucket_datalake"
  bucket_name = local.creation-bucket-name
  tags = {
    name  = local.creation-bucket-name
    env   = var.environment
    owner = "terraform"
  }
  lcr_id = local.creation-lcr-id
  lcr_tags = {
    name  = local.creation-lcr-id
    env   = var.environment
    owner = "terraform"
  }
  rc_iam_role_replication = module.iam_role_s3_creation_layer.role_arn
  rc_rule_id              = local.creation-rc-id
  rc_bucket_dest          = module.s3_creation_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_creation" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_creation_layer.bucket_id
}

module "s3_creation_layer_rep" {
  source      = "../modules/s3_bucket_datalake_rep"
  bucket_name = local.creation-rep-bucket-name
  tags = {
    name  = local.creation-rep-bucket-name
    env   = var.environment
    owner = "terraform"
  }
  lcr_id = local.creation-lcr-rep-id
  lcr_tags = {
    name  = local.creation-lcr-rep-id
    env   = var.environment
    owner = "terraform"
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_creation_rep" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_creation_layer_rep.bucket_id
}