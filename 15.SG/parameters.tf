resource "aws_ssm_parameter" "bastion_id" {
  name  = "/${var.project_name}/${var.environment}/bastion-sg-id"
  type  = "String"
  value = module.bastion.sg_id
}

resource "aws_ssm_parameter" "vpn_id" {
  name  = "/${var.project_name}/${var.environment}/vpn-sg-id"
  type  = "String"
  value = module.vpn.sg_id
}

resource "aws_ssm_parameter" "db_id" {
  name  = "/${var.project_name}/${var.environment}/db-sg-id"
  type  = "String"
  value = module.db.sg_id
}

resource "aws_ssm_parameter" "backend_id" {
  name  = "/${var.project_name}/${var.environment}/backend-sg-id"
  type  = "String"
  value = module.backend.sg_id
}

resource "aws_ssm_parameter" "frontend_id" {
  name  = "/${var.project_name}/${var.environment}/frontend-sg-id"
  type  = "String"
  value = module.frontend.sg_id
}

resource "aws_ssm_parameter" "internal_id" {
  name  = "/${var.project_name}/${var.environment}/internal-sg-id"
  type  = "String"
  value = module.internal_alb.sg_id
}

resource "aws_ssm_parameter" "external_id" {
  name  = "/${var.project_name}/${var.environment}/external-sg-id"
  type  = "String"
  value = module.external_alb.sg_id
}
