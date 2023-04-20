

output "rds_url" {
  value = module.microservice_resources.aws_db_instance.rds_instance.endpoint
}

output "iam_role_name" {
  value = module.microservice_resources.aws_

}

output "s3_bucket_name" {
  value = aws_s3_bucket.example.bucket
}