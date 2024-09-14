resource "aws_route53_record" "www" {
  zone_id         = var.zone_id
  name            = "expense"
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = aws_lb.test.dns_name
    zone_id                = aws_lb.test.zone_id
    evaluate_target_health = true
  }
}
