provider "aws" {}

module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "ci"
}

module "standard_registry" {
  source = "../../"

  name = "standard-registry"

  image_names = ["foobar"]

  preserved_image_tags = ["staging", "prod"]

  context = module.context
}

output "repository_url" {
  value = module.standard_registry.repository_urls["foobar"]
}
