data "aws_ssm_parameter" "internal_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/internal-sg-id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private-subnet-ids"
}




