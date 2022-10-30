output "cloudfront_url" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "dns_name_servers" {
  value = data.aws_route53_zone.main.name_servers
}

output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "bucket_name" {
  value = aws_s3_bucket.main.bucket
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.main.id
}