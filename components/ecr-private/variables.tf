variable "immutable_tags" {
  type    = bool
  default = true

  description = "Whether or not this registry should use immutable tags. Immutable tags will prevent images with tags that already exist to be pushed into the registry."
}

variable "kms_key_id" {
  type    = string
  default = null

  description = "The ID of a specific KMS key to use for encrypting the database. If not specified, the default AWS KMS key will be used."
}

variable "scan_on_push" {
  type    = bool
  default = true

  description = "Whether or not images pushed to the registry should be scanned for common vulnerabilities by AWS automatically."
}

variable "image_names" {
  type    = list(string)
  default = []

  description = "The list of image names for which to setup a registry. If none are given, the registry name is used as the sole image name."
}

variable "enable_default_lifecycle_policy" {
  type    = bool
  default = true

  description = "Wether or not to create the default lifecycle policies for all specified images."
}

variable "preserved_image_tags" {
  type    = list(string)
  default = []

  description = "A list of tag prefixes for image tags that should be excempt from expiring."
}

variable "max_preserved_image_count" {
  type    = number
  default = 10

  description = "The amount of images that shall not be expired for preserved tags."


}
