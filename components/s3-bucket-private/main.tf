/**
 * # s3-private
 *  
 * Provisions a private, secure S3 bucket.
 * 
 * The bucket enforces the following presets:
 *  * Encryption by either custom KMS key or default AWS AES:256 SSE encryption key
 *  * Upload of encrypted objects is enforced through policies
 *  * TLS 1.2 transport security is enforced when interacting with the bucket
 *  * Public access to the bucket is disabled
 * 
 * ## Usage example
 * 
 * ```hcl
 * module "context" {
 *   source = "github.com/spaceteams/terraform-space-context"
 * 
 *   namespace   = "spaceteams"
 *   environment = "ci"
 * }
 * 
 * module "bucket" {
 *   source = "github.com/spaceteams/terraform-aws-modules/components/s3-bucket-private"
 *
 *   name = "my-bucket"

 *   versioning = true   
 
 *   context = module.context
 * }
 * 
 * output "bucket_id" {
 *   value = module.bucket.bucket_id
 * }
 * ```
 * 
 */

locals {
  enabled = module.context.enabled

  bucket_name = module.context.label

  partition     = join("", [for p in data.aws_partition.current : p.partition])
  bucket_id     = join("", [for b in aws_s3_bucket.this : b.id])
  bucket_policy = join("", [for p in data.aws_iam_policy_document.prevent_unencrypted_uploads : p.json])
}

data "aws_partition" "current" {
  count = local.enabled ? 1 : 0
}

# Enforce that only encrypted objects are stored in the bucket
# either by supplying a KMS key or using the default account
# encryption key.
# Also enforce that all object requests use TLS transport security.
# See https://aws.amazon.com/blogs/security/how-to-prevent-uploads-of-unencrypted-objects-to-amazon-s3/
data "aws_iam_policy_document" "prevent_unencrypted_uploads" {
  count = local.enabled ? 1 : 0

  statement {
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:${local.partition}:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "aws:kms",
        "AES256"
      ]
    }
  }

  statement {

    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:${local.partition}:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "true"
      ]
    }
  }

  statement {
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:${local.partition}:s3:::${local.bucket_name}",
      "arn:${local.partition}:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:${local.partition}:s3:::${local.bucket_name}",
      "arn:${local.partition}:s3:::${local.bucket_name}/*",
    ]

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = ["1.2"]
    }
  }
}

resource "aws_s3_bucket" "this" {
  count = local.enabled ? 1 : 0

  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags          = module.context.tags
}

resource "aws_s3_bucket_policy" "this" {
  count = local.enabled && var.versioning_enabled ? 1 : 0

  bucket = local.bucket_id

  policy = local.bucket_policy
}

resource "aws_s3_bucket_versioning" "this" {
  count = local.enabled && var.versioning_enabled ? 1 : 0

  bucket = local.bucket_id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = local.enabled ? 1 : 0

  bucket = local.bucket_id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = var.kms_key_id == null ? "AES256" : "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = local.enabled && var.logging_configuration != null ? 1 : 0

  bucket = local.bucket_id

  target_bucket = var.logging_configuration.target_bucket
  target_prefix = var.logging_configuration.target_prefix
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = local.enabled ? 1 : 0

  bucket                  = local.bucket_id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
