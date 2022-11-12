provider "aws" {}

module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "modules"
  stage       = "dynamodb"

  tags = {
    "Tag" = "Value"
  }
}
module "kms_key" {
  source = "../../../kms-key"

  name = "dynamodb-key"

  context = module.context
}

module "dynamodb" {
  source = "../../"

  name = "complete"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = {
    name = "Name"
    type = "S"
  }

  range_key = {
    name = "time"
    type = "S"
  }

  context = module.context
}

output "table_name" {
  value = module.dynamodb.table_name
}
