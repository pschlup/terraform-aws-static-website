data "aws_route53_zone" "main" {
  name = var.domain
  id = var.zone_id
}
