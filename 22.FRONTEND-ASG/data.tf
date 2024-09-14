data "aws_ssm_parameter" "external_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/external-sg-id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private-subnet-ids"
}

data "aws_ssm_parameter" "external_htpps_listner_arn" {
  name = "/${var.project_name}/${var.environment}/https-listner-arn"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc-id"
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project_name}/${var.environment}/frontend-sg-id"
}

data "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-cloudwatch-logs-instance-profile"
}