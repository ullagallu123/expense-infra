resource "aws_ssm_parameter" "backend-alb-listner-arn" {
  name  = "/${var.project_name}/${var.environment}/internal-alb-http-listner-arn"
  type  = "String"
  value = aws_lb_listener.default.arn
}