variable "deletion_window_in_days" {
  type    = number
  default = 30

  description = "AWS KMS keys are cannot be deleted immediately. Instead, AWS will mark them for deletion for the number of days specified here, only after which the key will be permanently deleted. Until then, the key may be restored at any point."
}

variable "description" {
  type     = string
  default  = null
  nullable = true

  description = "The description of the key."
}

variable "alias" {
  type     = string
  default  = null
  nullable = true

  description = "The alias aka. the human readable name of this key that will be shown when being referenced by other services, eg. in the AWS console. If not specified, the context label will be used instead."
}

variable "enable_key_rotation" {
  type    = bool
  default = true

  description = <<EOT
    Set this to true for AWS to rotate the encryption material automatically on a regular basis.
    Key rotation does _not_ result in data being unaccessable that uses the old encryption material.
    AWS will keep all of the old material available for decryption indefinately.
    The new encryption material will only be used to encrypt new data.

    It is highly recommended to keep this enabled.
  EOT
}

variable "key_usage" {
  type     = string
  default  = null
  nullable = true

  description = "Specifies the intended use of the key."
}
