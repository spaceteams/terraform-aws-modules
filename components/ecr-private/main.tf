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
