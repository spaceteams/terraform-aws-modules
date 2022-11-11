provider "aws" {}

module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "project"
  stage       = "sandbox"

  tags = {
    "Tag" = "Value"
  }
}

module "bucket" {
  source = "../../"

  name = "simple"

  context = module.context
}

output "bucket_id" {
  value = module.bucket.bucket_id
}
output "bucket_arn" {
  value = module.bucket.bucket_arn
}
