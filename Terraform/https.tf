#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "rearcQuestApp" {
  load_balancer_arn = aws_alb.alb.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb-https" {
  load_balancer_arn = aws_alb.alb.id
  #port- port on which alb is listening
  port            = "443"
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.rearcQuestApp-tg.arn
  }
}

data "aws_route53_zone" "zone" {
  #name = "jakin.click."
  zone_id = "Z05267941K6MTOMGPPPWP"
  tags = {
    Name = "jakin.click"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "jakin.click"
  validation_method = "DNS"
  tags = {
    name = "acm-domain-cert"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "www" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.zone.id
  name            = "jakin.click"
  type            = "A"
  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = sort(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name)[0]
  type            = sort(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type)[0]
  zone_id         = data.aws_route53_zone.zone.id
  records         = [element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, 0)]
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
