resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.main.website_endpoint
    origin_id   = "${aws_s3_bucket_website_configuration.main.bucket}-bucket"

    custom_origin_config {
      origin_protocol_policy = "http-only"

      http_port  = "80"
      https_port = "443"

      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  comment = "Website ${data.aws_route53_zone.main.name}"

  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"

  default_root_object = "index.html"
  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket_website_configuration.main.bucket}-bucket"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600  # 60 m
    max_ttl     = 86400 # 24 h

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = [data.aws_route53_zone.main.name]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  price_class = "PriceClass_All"
}

resource "aws_cloudfront_distribution" "redirect" {
  count = var.redirect_www ? 1 : 0

  origin {
    domain_name = aws_s3_bucket_website_configuration.www-redirect[0].website_endpoint
    origin_id   = "${aws_s3_bucket_website_configuration.www-redirect[0].bucket}-bucket"

    custom_origin_config {
      origin_protocol_policy = "http-only"

      http_port  = "80"
      https_port = "443"

      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  comment = "Redirect www.${data.aws_route53_zone.main.name}"

  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket_website_configuration.www-redirect[0].bucket}-bucket"

    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 3600  # 60 m
    max_ttl     = 86400 # 24 h

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = ["www.${data.aws_route53_zone.main.name}"]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.main.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  price_class = "PriceClass_All"
}
