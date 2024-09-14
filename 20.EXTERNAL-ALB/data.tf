data "aws_ssm_parameter" "external_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/external-sg-id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public-subnet-ids"
}

data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/acm-certificate-arn"
}