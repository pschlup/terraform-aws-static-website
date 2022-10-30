resource "aws_route53_record" "cloudfront_A" {
  zone_id = data.aws_route53_zone.main.id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_AAAA" {
  zone_id = data.aws_route53_zone.main.id
  name    = ""
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_www_A" {
  count = var.redirect_www ? 1 : 0

  zone_id = data.aws_route53_zone.main.id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.redirect[0].domain_name
    zone_id                = aws_cloudfront_distribution.redirect[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_www_AAAA" {
  count = var.redirect_www ? 1 : 0

  zone_id = data.aws_route53_zone.main.id
  name    = "www"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.redirect[0].domain_name
    zone_id                = aws_cloudfront_distribution.redirect[0].hosted_zone_id
    evaluate_target_health = false
  }
}
