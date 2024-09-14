data "aws_ssm_parameter" "internal_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/internal-sg-id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private-subnet-ids"
}

data "aws_ssm_parameter" "backend_listner_arn" {
  name = "/${var.project_name}/${var.environment}/internal-alb-http-listner-arn"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc-id"
}

data "aws_ssm_parameter" "backend_id" {
  name = "/${var.project_name}/${var.environment}/backend-sg-id"
}

data "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-cloudwatch-logs-instance-profile"
}
