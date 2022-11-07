<!-- BEGIN_TF_DOCS -->
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

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_context"></a> [context](#input\_context)

Description:     Set this to pass down a complete context.  
    This is usually used to pass down the 'outer' context,  
    ie. the context of module invoking this one.  
    See [terraform-space-context](https://github.com/spaceteams/terraform-space-context) documentation   
    for details on how the context is commonly used.

Type: `any`

Default:

```json
{
  "enabled": true,
  "environment": null,
  "iam_permission_boundary": null,
  "name": null,
  "namespace": null,
  "stage": null,
  "suffix": [],
  "tags": {}
}
```

### <a name="input_enable_default_lifecycle_policy"></a> [enable\_default\_lifecycle\_policy](#input\_enable\_default\_lifecycle\_policy)

Description: Wether or not to create the default lifecycle policies for all specified images.

Type: `bool`

Default: `true`

### <a name="input_enabled"></a> [enabled](#input\_enabled)

Description: Set this to false in order to disable this module

Type: `bool`

Default: `true`

### <a name="input_iam_permission_boundary"></a> [iam\_permission\_boundary](#input\_iam\_permission\_boundary)

Description: A global boundary permission ARN that will be set to all iam roles created

Type: `string`

Default: `null`

### <a name="input_image_names"></a> [image\_names](#input\_image\_names)

Description: The list of image names for which to setup a registry. If none are given, the registry name is used as the sole image name.

Type: `list(string)`

Default: `[]`

### <a name="input_immutable_tags"></a> [immutable\_tags](#input\_immutable\_tags)

Description: Whether or not this registry should use immutable tags. Immutable tags will prevent images with tags that already exist to be pushed into the registry.

Type: `bool`

Default: `true`

### <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id)

Description: The ID of a specific KMS key to use for encrypting the database. If not specified, the default AWS KMS key will be used.

Type: `string`

Default: `null`

### <a name="input_max_preserved_image_count"></a> [max\_preserved\_image\_count](#input\_max\_preserved\_image\_count)

Description: The amount of images that shall not be expired for preserved tags.

Type: `number`

Default: `10`

### <a name="input_name"></a> [name](#input\_name)

Description:     The primary name or identifier of the resource.  
    It will automatically be added to the list of tags as the 'name' tag.

Type: `string`

Default: `null`

### <a name="input_preserved_image_tags"></a> [preserved\_image\_tags](#input\_preserved\_image\_tags)

Description: A list of tag prefixes for image tags that should be excempt from expiring.

Type: `list(string)`

Default: `[]`

### <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push)

Description: Whether or not images pushed to the registry should be scanned for common vulnerabilities by AWS automatically.

Type: `bool`

Default: `true`

### <a name="input_suffix"></a> [suffix](#input\_suffix)

Description: A list of suffixes to be ammended te the label.

Type: `list(string)`

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A set of tags added to the resource.

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_repository_arns"></a> [repository\_arns](#output\_repository\_arns)

Description: The ARNs of the created repositories by name.

### <a name="output_repository_ids"></a> [repository\_ids](#output\_repository\_ids)

Description: The IDs of the created repositories by name.

### <a name="output_repository_urls"></a> [repository\_urls](#output\_repository\_urls)

Description: The URLs of the created repositories by name.
<!-- END_TF_DOCS -->