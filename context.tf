module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  enabled                 = var.enabled
  name                    = var.name
  tags                    = var.tags
  suffix                  = var.suffix
  iam_permission_boundary = var.iam_permission_boundary

  parent = var.context
}

variable "context" {
  type = any
  default = {
    enabled                 = true
    name                    = null
    namespace               = null
    environment             = null
    stage                   = null
    suffix                  = []
    iam_permission_boundary = null
    tags                    = {}
  }

  description = <<EOT
    Set this to pass down a complete context.
    This is usually used to pass down the 'outer' context,
    ie. the context of module invoking this one.
    See [terraform-space-context](https://github.com/spaceteams/terraform-space-context) documentation 
    for details on how the context is commonly used.
  EOT
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set this to false in order to disable this module"
}

variable "name" {
  type        = string
  default     = null
  description = <<EOT
    The primary name or identifier of the resource.
    It will automatically be added to the list of tags as the 'name' tag.
  EOT
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A set of tags added to the resource."
}

variable "suffix" {
  type        = list(string)
  default     = []
  description = "A list of suffixes to be ammended te the label."
}

variable "iam_permission_boundary" {
  type        = string
  default     = null
  description = "A global boundary permission ARN that will be set to all iam roles created"
}
