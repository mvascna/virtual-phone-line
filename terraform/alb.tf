resource aws_lb vphone {
  name            = "vphone"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.load_balancer.id]

  tags = {
    Name = "vphone"
  }
}

resource aws_security_group load_balancer {
  vpc_id = module.vpc.vpc_id
  name   = "vphone-load-balancer"
}

resource aws_lb_listener load_balancer_https {
  load_balancer_arn = aws_lb.vphone.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.vphone.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "200"
      content_type = "text/plain"
      message_body = "vphone"
    }
  }
}

resource aws_security_group_rule load_balancer_https_ingress {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.load_balancer.id

  cidr_blocks = ["0.0.0.0/0"]
}

resource aws_security_group_rule load_balancer_https_egress {
  type              = "egress"
  from_port         = 32768
  to_port           = 61000
  protocol          = "tcp"
  security_group_id = aws_security_group.load_balancer.id

  source_security_group_id = aws_security_group.cluster.id
}
