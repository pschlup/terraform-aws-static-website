### bucket

resource "aws_s3_bucket" "main" {
  bucket = var.domain
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = <<EOT
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["${aws_s3_bucket.main.arn}/*"]
    }
  ]
}
EOT
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "deprecation"
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id

  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
  }
}

### www redirect

resource "aws_s3_bucket" "www-redirect" {
  count = var.redirect_www ? 1 : 0

  bucket = "${var.domain}-www-redirect"
}

resource "aws_s3_bucket_website_configuration" "www-redirect" {
  count = var.redirect_www ? 1 : 0

  bucket = aws_s3_bucket.www-redirect[0].id

  redirect_all_requests_to {
    host_name = data.aws_route53_zone.main.name
    protocol  = "https"
  }
}