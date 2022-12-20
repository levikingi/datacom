resource "aws_acm_certificate" "ssl" {
  domain_name       = "auckland.cloud"
  validation_method = "DNS"
}

locals {
  domain_validation_options_list = [for v in aws_acm_certificate.ssl.domain_validation_options : v]
}

resource "aws_route53_record" "ssl" {
  zone_id = aws_route53_zone.ssl.zone_id
  name    = element(local.domain_validation_options_list, 0).resource_record_name
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(local.domain_validation_options_list, 0).resource_record_value}"]
}

resource "aws_route53_zone" "ssl" {
  name = "auckland.cloud"
}
