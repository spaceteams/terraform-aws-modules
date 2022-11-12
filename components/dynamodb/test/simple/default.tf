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

module "dynamodb" {
  source = "../../"

  name = "simple"

  hash_key = {
    name = "Name"
    type = "S"
  }

  provisioned_read_capacity  = 1
  provisioned_write_capacity = 1

  context = module.context
}

output "table_name" {
  value = module.dynamodb.table_name
}
