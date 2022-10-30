# ecr-private

A private Elastic Container Registry with encryption and lifecycle policies by default.

This module will create one ECR instance per `image_name` given.


## Usage example

```hcl
module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "ci"
}

module "private_registry" {
  source = "github.com/spaceteams/terraform-aws-modules/components/ecr-private"

  name = "private-registry"

  image_names = ["my-service"]

  preserved_image_tags = ["staging", "prod"]

  context = module.context
}

output "my_service_url" {
  value = module.private_registry.urls["my-service"]
}
```

## Lifecycle policies

This module provides a set of default lifecycle rules for all registires created by it. This behavior can be disables by setting `enable_default_lifecycle_policy = false` in the modules arguments. It is recommended apply your own policies in that case.

The default lifecycle rules can be sumarized like the following:

 * If an image has no tag, expire it after 14 days, eg. when re-using the latest tag.

 * If an image is tagged and the tag is not covered by the `perserve_image_tags` given, expire the image after 60 days.

 * If an image is tagged and the tag is covered by the `perserve_image_tags` given, keep the `max_preserved_image_count` latest number of images by push date.

## Arguments

 * **name** (optional if image_names are given)
  
   The name of the container registry.

 * **image_names** (optional)
  
   The list of image names for which to create ECR instances. If omitted or empty, the registry name will be used as the sole image name.

   Example: `image_names = ["my-service-1", "web-server"`]

 * **kms_key_id** (optional)

   The ID of the KMS key used for encrypting images in this registry. If omitted, the default AWS KMS key will be used (default).

 * **scan_on_push** (optional)

   If set to `true` (default), images pushed to the registry will be scanned for common vulnerabilities automaticall.
   Set this to `false` to disable.
  
 * **immutable_tags** (optional)

   If set to `true` (default), the registry will not allow pushing an image tag if it already exists. To re-use tags, eg. the `latest` tag, set this to false.

 * **enable_default_lifecycle_policy** (optional)

   If set to `true` (default), the registry will be subject to the default lifecycle rules provided by this module. Set this value to `false` to disable.
   
 * **preserved_image_tags** (optional)
  
   A list of image tag prefixs to preserve from expiring by default.

   Example: `preserved_image_tags = ["staging", "prod"`]

 * **max_preserved_image_count** (optional)

   The number of images to preserve per `preserved_image_tag` from being expired.
   Default is `10`.

## Outputs

 * **repository_ids**
  
   The IDs of the created repositories by image name.

 * **repository_urls**
  
   The URLs of the created repositories by image name.

* **repository_arns**
  
   The ARNs of the created repositories by image name.
