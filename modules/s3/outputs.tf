output "name" {
  description = "Name of the S3 bucket created"
  value       = aws_s3_bucket.bucket.id
}

output "arn" {
  description = "ARN of the S3 bucket created"
  value       = aws_s3_bucket.bucket.arn
}
