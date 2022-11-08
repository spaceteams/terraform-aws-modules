provider "aws" {}

module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "project"
  stage       = "staging"

  tags = {
    "Tag" = "Value"
  }
}

module "kms_key" {
  source = "../../"

  name = "simple"

  deletion_window_in_days = 7
  context                 = module.context
}

output "key_arn" {
  value = module.kms_key.key_arn
}
output "alias_name" {
  value = module.kms_key.alias_name
}
