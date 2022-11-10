<!-- BEGIN_TF_DOCS -->
# kms-key

This module provisions a KMS key with alias.

## Usage example

```hcl
module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "ci"
}

module "kms_key" {
  source = "github.com/spaceteams/terraform-aws-modules/components/kms-key"

  name = "kms-key"
  alias = "kms-key"

  context = module.context
}

output "kms_key_id" {
  value = module.kms_key.key_id
}
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_alias"></a> [alias](#input\_alias)

Description: The alias aka. the human readable name of this key that will be shown when being referenced by other services, eg. in the AWS console. If not specified, the context label will be used instead.

Type: `string`

Default: `null`

### <a name="input_context"></a> [context](#input\_context)

Description:     Set this to pass down a complete context.  
    This is usually used to pass down the 'outer' context,  
    ie. the context of module invoking this one.  
    See [terraform-space-context](https://github.com/spaceteams/terraform-space-context) documentation   
    for details on how the context is commonly used.  
    All context values can be override via inputs on the module level.

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

### <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days)

Description: AWS KMS keys are cannot be deleted immediately. Instead, AWS will mark them for deletion for the number of days specified here, only after which the key will be permanently deleted. Until then, the key may be restored at any point.

Type: `number`

Default: `30`

### <a name="input_description"></a> [description](#input\_description)

Description: The description of the key.

Type: `string`

Default: `null`

### <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation)

Description:     Set this to true for AWS to rotate the encryption material automatically on a regular basis.  
    Key rotation does _not_ result in data being unaccessable that uses the old encryption material.  
    AWS will keep all of the old material available for decryption indefinately.  
    The new encryption material will only be used to encrypt new data.

    It is highly recommended to keep this enabled.

Type: `bool`

Default: `true`

### <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage)

Description: Specifies the intended use of the key.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_alias_arn"></a> [alias\_arn](#output\_alias\_arn)

Description: The ARN of the alias associated with the KMS key

### <a name="output_alias_name"></a> [alias\_name](#output\_alias\_name)

Description: The alias name associated with the KMS key

### <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn)

Description: The ARN of the KMS key

### <a name="output_key_id"></a> [key\_id](#output\_key\_id)

Description: The ID of the KMS key
<!-- END_TF_DOCS -->