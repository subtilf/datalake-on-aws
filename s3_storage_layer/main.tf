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
    name  = "kms-sublab-dl-lab"
    env   = "lab"
    owner = "terraform"
  }
}

###########################
## Policy for raw bucket ##
###########################

module "iam_role_s3_raw_layer" {
  source        = "../modules/iam_role"
  iam_role_name = "iam_role_s3_raw_layer"
  tags = {
    name  = "iam-role-sublab-s3-raw-us-east-2"
    env   = "lab"
    owner = "terraform"
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_raw" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    effect = "Allow"
    resources = [
      module.s3_raw_layer.bucket_arn,
      format("%s%s", module.s3_raw_layer.bucket_arn, "/*"),
      module.s3_raw_layer_rep.bucket_arn,
      format("%s%s", module.s3_raw_layer_rep.bucket_arn, "/*")
    ]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
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
    resources = [
      format("%s%s", module.s3_raw_layer_rep.bucket_arn, "/*")
    ]
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
  iam_policy_name = "iam_policy_s3_raw_layer"
  iam_policy_desc = "Policy the container all rules for the replication works for raw layer!"
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_raw.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_raw_layer" {
  role       = module.iam_role_s3_raw_layer.role_name
  policy_arn = module.iam_policy_s3_raw_layer.policy_arn
}

################################
## Policy for standard bucket ##
################################

module "iam_role_s3_standard_layer" {
  source        = "../modules/iam_role"
  iam_role_name = "iam_role_s3_standard_layer"
  tags = {
    name  = "iam-role-sublab-s3-standard-us-east-2"
    env   = "lab"
    owner = "terraform"
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_standard" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    effect = "Allow"
    resources = [
      module.s3_standard_layer.bucket_arn,
      format("%s%s", module.s3_standard_layer.bucket_arn, "/*"),
      module.s3_standard_layer_rep.bucket_arn,
      format("%s%s", module.s3_standard_layer_rep.bucket_arn, "/*")
    ]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
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
    resources = [
      format("%s%s", module.s3_standard_layer_rep.bucket_arn, "/*")
    ]
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
  iam_policy_name = "iam_policy_s3_standard_layer"
  iam_policy_desc = "Policy the container all rules for the replication works for standard layer!"
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_standard.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_standard_layer" {
  role       = module.iam_role_s3_standard_layer.role_name
  policy_arn = module.iam_policy_s3_standard_layer.policy_arn
}

################################
## Policy for standard bucket ##
################################

module "iam_role_s3_creation_layer" {
  source        = "../modules/iam_role"
  iam_role_name = "iam_role_s3_creation_layer"
  tags = {
    name  = "iam-role-sublab-s3-creation-us-east-2"
    env   = "lab"
    owner = "terraform"
  }
  iam_role_policy = file("../iam_policy_files/trust_relationship_s3.json")
}

data "aws_iam_policy_document" "iam_policy_doc_creation" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]
    effect = "Allow"
    resources = [
      module.s3_creation_layer.bucket_arn,
      format("%s%s", module.s3_creation_layer.bucket_arn, "/*"),
      module.s3_creation_layer_rep.bucket_arn,
      format("%s%s", module.s3_creation_layer_rep.bucket_arn, "/*")
    ]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
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
    resources = [
      format("%s%s", module.s3_creation_layer_rep.bucket_arn, "/*")
    ]
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
  iam_policy_name = "iam_policy_s3_creation_layer"
  iam_policy_desc = "Policy the container all rules for the replication works for creation layer!"
  iam_policy_path = "/"
  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_creation.json
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment_s3_creation_layer" {
  role       = module.iam_role_s3_creation_layer.role_name
  policy_arn = module.iam_policy_s3_creation_layer.policy_arn
}

#########################
## Buckets declaration ##
#########################

module "s3_raw_layer" {
  source      = "../modules/s3_bucket_datalake"
  bucket_name = "s3-sublab-raw-layer-lab"
  tags = {
    name  = "s3-sublab-raw-layer-lab"
    env   = "lab"
    owner = "terraform"
  }
  lcr_id = "s3_raw_layer_lcr_rule"
  lcr_tags = {
    name  = "s3_raw_layer_lcr_rule"
    env   = "lab"
    owner = "terraform"
  }
  rc_iam_role_replication = module.iam_role_s3_raw_layer.role_arn
  rc_rule_id              = "s3_raw_layer_rc_rule"
  rc_bucket_dest          = module.s3_raw_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_raw" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_raw_layer.bucket_id
}

module "s3_raw_layer_rep" {
  source      = "../modules/s3_bucket_datalake_rep"
  bucket_name = "s3-sublab-raw-rep-layer-lab"
  tags = {
    name  = "s3-sublab-raw-rep-layer-lab"
    env   = "lab"
    owner = "terraform"
  }
  lcr_id = "s3_raw_rep_layer_lcr_rule"
  lcr_tags = {
    name  = "s3_raw_rep_layer_lcr_rule"
    env   = "lab"
    owner = "terraform"
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_raw_rep" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_raw_layer_rep.bucket_id
}

module "s3_standard_layer" {
  source      = "../modules/s3_bucket_datalake"
  bucket_name = "s3-sublab-standard-layer-lab"
  tags = {
    name  = "s3-sublab-standard-layer-lab"
    env   = "lab"
    owner = "terraform"
  }
  lcr_id = "s3_standard_layer_lcr_rule"
  lcr_tags = {
    name  = "s3_standard_layer_lcr_rule"
    env   = "lab"
    owner = "terraform"
  }
  rc_iam_role_replication = module.iam_role_s3_standard_layer.role_arn
  rc_rule_id              = "s3_standard_layer_rc_rule"
  rc_bucket_dest          = module.s3_standard_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_standard" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_standard_layer.bucket_id
}

module "s3_standard_layer_rep" {
  source      = "../modules/s3_bucket_datalake_rep"
  bucket_name = "s3-sublab-standard-rep-layer-lab"
  tags = {
    name  = "s3-sublab-standard-rep-layer-lab"
    env   = "lab"
    owner = "terraform"
  }
  lcr_id = "s3_standard_rep_layer_lcr_rule"
  lcr_tags = {
    name  = "s3_standard_rep_layer_lcr_rule"
    env   = "lab"
    owner = "terraform"
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
  ## BUG ##
  #rc_rule_id = "na"
  #rc_iam_role_replication = "na"
  #rc_bucket_dest = "na"
}

module "s3_bucket_pub_access_block_standard_rep" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_standard_layer_rep.bucket_id
}

module "s3_creation_layer" {
  source      = "../modules/s3_bucket_datalake"
  bucket_name = "s3-sublab-creation-layer-lab"
  tags = {
    name  = "s3-sublab-creation-layer-lab"
    env   = "lab"
    owner = "terraform"
  }
  lcr_id = "s3_creation_layer_lcr_rule"
  lcr_tags = {
    name  = "s3_creation_layer_lcr_rule"
    env   = "lab"
    owner = "terraform"
  }
  rc_iam_role_replication = module.iam_role_s3_creation_layer.role_arn
  rc_rule_id              = "s3_creation_layer_rc_rule"
  rc_bucket_dest          = module.s3_creation_layer_rep.bucket_arn
  rc_kms_key              = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_creation" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_creation_layer.bucket_id
}

module "s3_creation_layer_rep" {
  source      = "../modules/s3_bucket_datalake_rep"
  bucket_name = "s3-sublab-creation-rep-layer-lab"
  tags = {
    name  = "s3-sublab-creation-rep-layer-lab"
    env   = "lab"
    owner = "terraform"
  }
  lcr_id = "s3_creation_rep_layer_lcr_rule"
  lcr_tags = {
    name  = "s3_creation_rep_layer_lcr_rule"
    env   = "lab"
    owner = "terraform"
  }
  lcr_exp_days = 90
  rc_kms_key   = module.kms_datalake_key.kms_arn
}

module "s3_bucket_pub_access_block_creation_rep" {
  source    = "../modules/s3_bucket_put_access_block"
  BUCKET_ID = module.s3_creation_layer_rep.bucket_id
}

data "aws_iam_policy_document" "iam_policy_doc_dl_users" {
  statement {
    actions = [
      "s3:GetObjectVersionTorrent",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:GetObjectTorrent",
      "s3:GetObjectRetention",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectLegalHold",
      "s3:GetObjectVersion"
    ]
    effect = "Allow"
    resources = [
      format("%s%s", module.s3_raw_layer.bucket_arn, "/*"),
      format("%s%s", module.s3_raw_layer_rep.bucket_arn, "/*")
    ]
  }
}

#module "iam_policy_dl_users"{
#  source = "../modules/iam_policy"
#  iam_policy_name = "iam_policy_dl_users"
#  iam_policy_desc = "Policy the container all rules for the replication works for raw layer!"
#  iam_policy_path = "/"
#  iam_policy_json = data.aws_iam_policy_document.iam_policy_doc_raw.json
#}
#
#resource "aws_iam_group" "iam_group_dl_users" {
#  name = "iam_group_dl_users"
#  path = "/"
#}
#
#resource "aws_iam_group_policy_attachment" "test-attach" {
#  group      = aws_iam_group.iam_group_dl_users.name
#  policy_arn = module.iam_policy_dl_users.policy_arn
#}
