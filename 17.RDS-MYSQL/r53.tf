resource "aws_route53_record" "db" {
  zone_id         = var.zone_id
  name            = "expense.db"
  type            = "CNAME"
  ttl             = 1
  records         = ["${module.db.db_instance_address}"]
  allow_overwrite = true
}