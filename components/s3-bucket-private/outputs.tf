output "bucket_id" {
  value       = join("", [for b in aws_s3_bucket.this : b.id])
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = join("", [for b in aws_s3_bucket.this : b.arn])
  description = "The ARN of the bucket"
}
