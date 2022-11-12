output "table_name" {
  value       = join("", [for table in aws_dynamodb_table.this : table.name])
  description = "The name DynamoDB table"
}

output "table_id" {
  value       = join("", [for table in aws_dynamodb_table.this : table.id])
  description = "The ID of the DynamoDB table"
}

output "table_arn" {
  value       = join("", [for table in aws_dynamodb_table.this : table.arn])
  description = "The ARN of the DynamoDB table"
}
