<!-- BEGIN_TF_DOCS -->
# dynamodb

This module provisions a DynamoDB table.

## Usage example

```hcl
module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "ci"
}

module "dynamodb" {
  source = "github.com/spaceteams/terraform-aws-modules/components/dynamodb"

  name = "dynamodb"
  billing_mode = "PAY_PER_REQUEST"

  context = module.context
}

output "dynamodb_id" {
  value = module.dynamodb.table_id
}
```

## Required Inputs

The following input variables are required:

### <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key)

Description: Name and type of the hash key in the index

Type:

```hcl
object({
    name = string
    type = string
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode)

Description:     Determines how you are charged for the DynamoDB table.

    If PROVISIONED, you are charged based on pre-determined reads or writes on the table.  
    This mode is a good choice if you can forecast traffic and/or capacity of your workload,  
    in which case pre-provisioning capacity will help reduce cost.  
    If your workload is not easily predictable, but will ramp up gradually, consider using  
    PROVISIONED mode with autoscaling.  
    See [AWS documentation](https://aws.amazon.com/dynamodb/pricing/provisioned/) for details.  

    If PAY\_PER\_REQUEST, you are charged based on the number of requests made.  
    This mode is a good choice for workloads with unpredictable or small workloads where  
    provisioning fixed resources does not make a lot of sense. It is more costly per request  
    that PROVISIONED mode, however you are not charged for capacity you don't use.  
    See [AWS documentation](https://aws.amazon.com/dynamodb/pricing/on-demand/) for details.

Type: `string`

Default: `"PROVISIONED"`

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

### <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn)

Description: If specified, the given KMS key will be used for encrypting data by default. If omitted, the default AWS AWS:256 key is used.

Type: `string`

Default: `null`

### <a name="input_provisioned_read_capacity"></a> [provisioned\_read\_capacity](#input\_provisioned\_read\_capacity)

Description: The read capacity for this table if billing\_mode is PROVISIONED.

Type: `number`

Default: `null`

### <a name="input_provisioned_write_capacity"></a> [provisioned\_write\_capacity](#input\_provisioned\_write\_capacity)

Description: The write capacity for this table if billing\_mode is PROVISIONED.

Type: `number`

Default: `null`

### <a name="input_range_key"></a> [range\_key](#input\_range\_key)

Description: Name and type of the range key in the index

Type:

```hcl
object({
    name = string
    type = string
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn)

Description: The ARN of the DynamoDB table

### <a name="output_table_id"></a> [table\_id](#output\_table\_id)

Description: The ID of the DynamoDB table

### <a name="output_table_name"></a> [table\_name](#output\_table\_name)

Description: The name DynamoDB table
<!-- END_TF_DOCS -->