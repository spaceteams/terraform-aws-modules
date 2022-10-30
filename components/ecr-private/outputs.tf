output "repository_ids" {
  value = zipmap(
    values(aws_ecr_repository.this)[*].name,
    values(aws_ecr_repository.this)[*].id
  )

  description = "The IDs of the created repositories by name."
}

output "repository_urls" {
  value = zipmap(
    values(aws_ecr_repository.this)[*].name,
    values(aws_ecr_repository.this)[*].repository_url
  )

  description = "The URLs of the created repositories by name."
}

output "repository_arns" {
  value = zipmap(
    values(aws_ecr_repository.this)[*].name,
    values(aws_ecr_repository.this)[*].arn
  )

  description = "The ARNs of the created repositories by name."
}
