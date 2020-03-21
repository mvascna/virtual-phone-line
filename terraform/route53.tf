data aws_route53_zone vphone {
  name = "vphone.bmltenabled.org."
}

resource aws_route53_record vphone {
  zone_id = data.aws_route53_zone.vphone.id
  name    = data.aws_route53_zone.vphone.name
  type    = "A"

  alias {
    name                   = aws_lb.vphone.dns_name
    zone_id                = aws_lb.vphone.zone_id
    evaluate_target_health = false
  }
}

resource aws_route53_record vphone_certificate_validation {
  name    = aws_acm_certificate.vphone.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.vphone.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.vphone.zone_id
  records = [aws_acm_certificate.vphone.domain_validation_options[0].resource_record_value]
  ttl     = 60
}
