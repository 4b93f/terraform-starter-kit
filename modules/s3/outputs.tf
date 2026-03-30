output "bucket_name" {
  description = "Arn of the bucket created"
  value       = aws_s3_bucket.my_bucket.arn
}