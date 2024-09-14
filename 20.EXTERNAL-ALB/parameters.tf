resource "aws_ssm_parameter" "external-alb-listner-arn" {
  name  = "/${var.project_name}/${var.environment}/external-listner-arn"
  type  = "String"
  value = aws_lb_listener.default.arn
}
resource "aws_ssm_parameter" "https-listner-arn" {
  name  = "/${var.project_name}/${var.environment}/https-listner-arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}
