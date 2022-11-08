output "key_arn" {
  value = join("", aws_kms_key.this.*.arn)

  description = "The ARN of the KMS key"
}

output "key_id" {
  value = join("", aws_kms_key.this.*.id)

  description = "The ID of the KMS key"
}
output "alias_name" {
  value = join("", aws_kms_alias.this.*.name)

  description = "The alias name associated with the KMS key"
}
output "alias_arn" {
  value = join("", aws_kms_alias.this.*.arn)

  description = "The ARN of the alias associated with the KMS key"
}
