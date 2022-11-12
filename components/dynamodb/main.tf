/**
 * # dynamodb
 *  
 * This module provisions a DynamoDB table.
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
 * module "dynamodb" {
 *   source = "github.com/spaceteams/terraform-aws-modules/components/dynamodb"
 *
 *   name = "dynamodb"
 *   billing_mode = "PAY_PER_REQUEST"
 *
 *   context = module.context
 * }
 * 
 * output "dynamodb_id" {
 *   value = module.dynamodb.table_id
 * }
 * ```
 */

locals {
  enabled = module.context.enabled

  key_attributes = concat([var.hash_key], var.range_key == null ? [] : [var.range_key])
  attributes     = local.key_attributes
}

resource "aws_dynamodb_table" "this" {
  count = local.enabled ? 1 : 0

  name = module.context.label

  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PAY_PER_REQUEST" ? null : var.provisioned_read_capacity
  write_capacity = var.billing_mode == "PAY_PER_REQUEST" ? null : var.provisioned_write_capacity

  hash_key  = var.hash_key.name
  range_key = try(var.range_key.name, null)

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  dynamic "attribute" {
    for_each = local.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = module.context.tags
}
