variable "billing_mode" {
  type    = string
  default = "PROVISIONED"

  description = <<EOT
    Determines how you are charged for the DynamoDB table.

    If PROVISIONED, you are charged based on pre-determined reads or writes on the table.
    This mode is a good choice if you can forecast traffic and/or capacity of your workload,
    in which case pre-provisioning capacity will help reduce cost.
    If your workload is not easily predictable, but will ramp up gradually, consider using
    PROVISIONED mode with autoscaling.
    See [AWS documentation](https://aws.amazon.com/dynamodb/pricing/provisioned/) for details.
    
    If PAY_PER_REQUEST, you are charged based on the number of requests made.
    This mode is a good choice for workloads with unpredictable or small workloads where
    provisioning fixed resources does not make a lot of sense. It is more costly per request
    that PROVISIONED mode, however you are not charged for capacity you don't use.
    See [AWS documentation](https://aws.amazon.com/dynamodb/pricing/on-demand/) for details.
  EOT
}

variable "provisioned_read_capacity" {
  type     = number
  default  = null
  nullable = true

  description = "The read capacity for this table if billing_mode is PROVISIONED."
}

variable "provisioned_write_capacity" {
  type     = number
  default  = null
  nullable = true

  description = "The write capacity for this table if billing_mode is PROVISIONED."
}

variable "hash_key" {
  type = object({
    name = string
    type = string
  })

  description = "Name and type of the hash key in the index"
}

variable "range_key" {
  type = object({
    name = string
    type = string
  })
  default  = null
  nullable = true

  description = "Name and type of the range key in the index"
}

variable "kms_key_arn" {
  type     = string
  default  = null
  nullable = true

  description = "If specified, the given KMS key will be used for encrypting data by default. If omitted, the default AWS AWS:256 key is used."
}
