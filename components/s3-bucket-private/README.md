<!-- BEGIN_TF_DOCS -->
# s3-private

Provisions a private, secure S3 bucket.

The bucket enforces the following presets:
 * Encryption by either custom KMS key or default AWS AES:256 SSE encryption key
 * Upload of encrypted objects is enforced through policies
 * TLS 1.2 transport security is enforced when interacting with the bucket
 * Public access to the bucket is disabled

## Usage example

```hcl
module "context" {
  source = "github.com/spaceteams/terraform-space-context"

  namespace   = "spaceteams"
  environment = "ci"
}

module "bucket" {
  source = "github.com/spaceteams/terraform-aws-modules/components/s3-bucket-private"

  name = "my-bucket"
```

## Optional Inputs

The following input variables are optional (have default values):

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

### <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy)

Description: If set to true, this bucket can be destroyed even if it still contains objects.

Type: `bool`

Default: `false`

### <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id)

Description: If specified, the given KMS key will be used for encrypting objects by default. If omitted, the default AWS AWS:256 key is used.

Type: `string`

Default: `null`

### <a name="input_logging_configuration"></a> [logging\_configuration](#input\_logging\_configuration)

Description:     If set, enables access logging for this bucket.  
    The target\_bucket\_name must contain he name of the bucket storing the logs,  
    the target\_prefix must specify a key prefix for log objects, eg. 'logs/'

Type:

```hcl
object({
    target_bucket = string
    target_prefix = string
  })
```

Default: `null`

### <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled)

Description: Turns on versioning for bucket objects.

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn)

Description: The ARN of the bucket

### <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id)

Description: The name of the bucket
<!-- END_TF_DOCS -->