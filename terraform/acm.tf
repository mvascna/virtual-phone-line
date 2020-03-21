resource aws_acm_certificate vphone {
  domain_name       = aws_route53_record.vphone.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

//resource aws_acm_certificate_validation vphone {
//  certificate_arn         = aws_acm_certificate.vphone.arn
//  validation_record_fqdns = [aws_route53_record.vphone.fqdn]
//}
