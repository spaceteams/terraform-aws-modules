output "key_arn" {
  value = join("", [for key in aws_kms_key.this : key.arn])

  description = "The ARN of the KMS key"
}

output "key_id" {
  value = join("", [for key in aws_kms_key.this : key.id])

  description = "The ID of the KMS key"
}
output "alias_name" {
  value = join("", [for alias in aws_kms_alias.this : alias.name])

  description = "The alias name associated with the KMS key"
}
output "alias_arn" {
  value = join("", [for alias in aws_kms_alias.this : alias.arn])

  description = "The ARN of the alias associated with the KMS key"
}
