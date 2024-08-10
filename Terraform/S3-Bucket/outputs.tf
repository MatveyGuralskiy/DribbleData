#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

output "S3_Bucket_name_Remote" {
  value = aws_s3_bucket.Bucket_Remote.bucket_domain_name
}

output "S3_Bucket_name_Project" {
  value = aws_s3_bucket.Bucket_Project.bucket_domain_name
}

output "CloudFront_URL" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

