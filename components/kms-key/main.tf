/**
 * # kms-key
 *  
 * This module provisions a KMS key with alias.
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
 * module "kms_key" {
 *   source = "github.com/spaceteams/terraform-aws-modules/components/kms-key"
 *
 *   name = "kms-key"
 *   alias = "kms-key"
 *
 *   context = module.context
 * }
 * 
 * output "kms_key_id" {
 *   value = module.kms_key.key_id
 * }
 * ```
 */

locals {
  enabled = module.context.enabled
}

resource "aws_kms_key" "this" {
  count = local.enabled ? 1 : 0

  enable_key_rotation     = var.enable_key_rotation
  deletion_window_in_days = var.deletion_window_in_days
  description             = coalesce(var.description, module.context.label)
  key_usage               = var.key_usage

  tags = module.context.tags
}

resource "aws_kms_alias" "this" {
  count = local.enabled ? 1 : 0

  name          = "alias/${coalesce(var.alias, module.context.label)}"
  target_key_id = join("", [for key in aws_kms_key.this : key.id])
}
