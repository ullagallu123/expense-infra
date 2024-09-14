resource "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/acm-certificate-arn"
  type  = "String"
  value = aws_acm_certificate.expense.arn
}