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

module "kms_key" {
  source = "../../../kms-key"

  name = "bucket-key"

  context = module.context
}

module "bucket" {
  source = "../../"

  name = "complex"

  logging_configuration = {
    target_bucket = module.logging_bucket.bucket_id
    target_prefix = "foo/"
  }

  kms_key_id = module.kms_key.key_id

  context = module.context
}

module "logging_bucket" {
  source = "../../"

  name = "logging"

  context = module.context
}

output "bucket_id" {
  value = module.bucket.bucket_id
}
output "logging_bucket_id" {
  value = module.logging_bucket.bucket_id
}
