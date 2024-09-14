data "aws_ssm_parameter" "db_subnets_group_name" {
  name = "/${var.project_name}/${var.environment}/db-subnet-group-name"
}
data "aws_ssm_parameter" "db_sg_id" {
  name = "/${var.project_name}/${var.environment}/db-sg-id"
}
