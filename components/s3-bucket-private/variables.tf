
variable "kms_key_id" {
  type     = string
  default  = null
  nullable = true

  description = "If specified, the given KMS key will be used for encrypting objects by default. If omitted, the default AWS AWS:256 key is used."
}

variable "versioning_enabled" {
  type    = bool
  default = false

  description = "Turns on versioning for bucket objects."
}

variable "force_destroy" {
  type    = bool
  default = false

  description = "If set to true, this bucket can be destroyed even if it still contains objects."
}

variable "logging_configuration" {
  type = object({
    target_bucket = string
    target_prefix = string
  })

  default  = null
  nullable = true

  validation {
    condition     = var.logging_configuration == null || endswith(try(var.logging_configuration.target_prefix, ""), "/")
    error_message = "The target_prefix parameter must end with a '/'."
  }

  description = <<EOT
    If set, enables access logging for this bucket.
    The target_bucket_name must contain he name of the bucket storing the logs,
    the target_prefix must specify a key prefix for log objects, eg. 'logs/'
  EOT
}
