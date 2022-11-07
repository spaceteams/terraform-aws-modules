/**
 * # ecr-private
 *  
 * A private Elastic Container Registry with encryption and lifecycle policies by default.
 * 
 * This module will create one ECR instance per `image_name` given.
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
 * module "private_registry" {
 *   source = "github.com/spaceteams/terraform-aws-modules/components/ecr-private"
 * 
 *   name = "private-registry"
 * 
 *   image_names = ["my-service"]
 * 
 *   preserved_image_tags = ["staging", "prod"]
 * 
 *   context = module.context
 * }
 * 
 * output "my_service_url" {
 *   value = module.private_registry.urls["my-service"]
 * }
 * ```
 * 
 * ## Lifecycle policies
 * 
 * This module provides a set of default lifecycle rules for all registires created by it. This behavior can be disables by setting `enable_default_lifecycle_policy = false` in the modules arguments. It is recommended apply your own policies in that case.
 * 
 * The default lifecycle rules can be sumarized like the following:
 * 
 *  * If an image has no tag, expire it after 14 days, eg. when re-using the latest tag.
 * 
 *  * If an image is tagged and the tag is not covered by the `perserve_image_tags` given, expire the image after 60 days.
 * 
 *  * If an image is tagged and the tag is covered by the `perserve_image_tags` given, keep the `max_preserved_image_count` latest number of images by push date.
 *
 */

locals {
  image_names = length(var.image_names) > 0 ? var.image_names : [module.context.name]
  enabled     = module.context.enabled
}

resource "aws_ecr_repository" "this" {
  for_each = toset(local.enabled ? local.image_names : [])

  name                 = each.value
  image_tag_mutability = var.immutable_tags ? "IMMUTABLE" : "MUTABLE"

  encryption_configuration {
    encryption_type = var.kms_key_id == null ? "AES256" : var.kms_key_id
    kms_key         = var.kms_key_id
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = module.context.tags
}

locals {
  untagged_image_rule = [{
    rulePriority = length(var.preserved_image_tags) + 1
    description  = "Expire untagged images"
    selection = {
      tagStatus   = "untagged"
      countType   = "sinceImagePushed"
      countUnit   = "days"
      countNumber = 14
    }
    action = {
      type = "expire"
    }
  }]

  remove_old_image_rule = [{
    rulePriority = length(var.preserved_image_tags) + 2
    description  = "Expire unprotected tagged images after 60 days"
    selection = {
      tagStatus   = "any"
      countType   = "sinceImagePushed"
      countUnit   = "days"
      countNumber = 60
    }
    action = {
      type = "expire"
    }
  }]

  preserve_images_rule = [
    for index, tagPrefix in zipmap(range(length(var.preserved_image_tags)), tolist(var.preserved_image_tags)) :
    {
      rulePriority = tonumber(index) + 1
      description  = "Preserve images tagged with ${tagPrefix}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = [tagPrefix]
        countType     = "imageCountMoreThan"
        countNumber   = var.max_preserved_image_count
      }
      action = {
        type = "expire"
      }
    }
  ]
}
resource "aws_ecr_lifecycle_policy" "this" {
  for_each = toset(local.enabled && var.enable_default_lifecycle_policy ? local.image_names : [])

  repository = aws_ecr_repository.this[each.value].name

  policy = jsonencode({
    rules = concat(local.preserve_images_rule, local.untagged_image_rule, local.remove_old_image_rule)
  })
}
