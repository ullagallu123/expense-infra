locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "bastion" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "bastion"
  vpc_id         = local.vpc_id
  sg_description = "This Sg was used for bastion"
  common_tags    = var.common_tags
}

module "vpn" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "vpn"
  vpc_id         = local.vpc_id
  sg_description = "This SG was used for vpn"
  common_tags    = var.common_tags
}

module "db" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "db"
  vpc_id         = local.vpc_id
  sg_description = "This SG was used for db"
  common_tags    = var.common_tags
}

module "backend" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "backend"
  vpc_id         = local.vpc_id
  sg_description = "This SG was used for backend"
  common_tags    = var.common_tags
}

module "frontend" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "frontend"
  vpc_id         = local.vpc_id
  sg_description = "This SG was used for frontend"
  common_tags    = var.common_tags
}

module "internal_alb" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "internal-alb"
  vpc_id         = local.vpc_id
  sg_description = "This SG was used for internal_alb"
  common_tags    = var.common_tags
}
module "external_alb" {
  source         = "git::https://github.com/ullagallu123/sg.git?ref=main"
  project_name   = var.project_name
  environment    = var.environment
  name           = "external-alb"
  vpc_id         = local.vpc_id
  sg_description = "This SG was used for external_alb"
  common_tags    = var.common_tags
}

# DB Rules
resource "aws_security_group_rule" "db_vpn" {
  description              = "This rule allows traffic from vpn on port 3306"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  description              = "This rule allows traffic from bastion on port 3306"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.db.sg_id
}

resource "aws_security_group_rule" "db_backend" {
  description              = "This rule allows traffic from backend on port 3306"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id        = module.db.sg_id
}

# Bastion
resource "aws_security_group_rule" "bastion_ssh" {
  description       = "This rule allows all traffic from internet on 22"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# VPN
resource "aws_security_group_rule" "vpn_ssh" {
  description       = "This rule allows all traffic from internet on 22"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "vpn_https" {
  description       = "This rule allows all traffic from internet on 443"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_et" {
  description       = "This rule allows all traffic from internet on 992"
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "vpn_udp" {
  description       = "This rule allows all traffic from internet on 1194"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# backend
resource "aws_security_group_rule" "backend_bastion_ssh" {
  description              = "This rule allow traffic from bastion on 22"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_bastion_tcp" {
  description              = "This rule allow traffic from bastion on 8080"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  description              = "This rule allow traffic from vpn on 22"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_vpn_tcp" {
  description              = "This rule allow traffic from vpn on 8080"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_internal_alb_tcp" {
  description              = "This rule allow traffic from internal alb on 8080"
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.internal_alb.sg_id
  security_group_id        = module.backend.sg_id
}

# Frontend

resource "aws_security_group_rule" "frontend_bastion_ssh" {
  description              = "This rule allow traffic from bastion on 22"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_bastion_http" {
  description              = "This rule allow traffic from bastion on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_vpn_ssh" {
  description              = "This rule allow traffic from vpn on 22"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_vpn_http" {
  description              = "This rule allow traffic from vpn on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_external_alb" {
  description              = "This rule allow traffic from external alb on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.external_alb.sg_id
  security_group_id        = module.frontend.sg_id
}

# internal ALB
resource "aws_security_group_rule" "internal_alb_bastion_http" {
  description              = "This rule allow traffic from bastion on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.internal_alb.sg_id
}
resource "aws_security_group_rule" "internal_alb_vpn_http" {
  description              = "This rule allow traffic from bastion on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.internal_alb.sg_id
}
resource "aws_security_group_rule" "internal_alb_frontend_http" {
  description              = "This rule allow traffic from bastion on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id        = module.internal_alb.sg_id
}

# external ALB

resource "aws_security_group_rule" "external_alb_bastion_http" {
  description              = "This rule allow traffic from bastion on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.external_alb.sg_id
}
resource "aws_security_group_rule" "external_alb_vpn_tcp" {
  description              = "This rule allow traffic from bastion on 80"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.external_alb.sg_id
}
resource "aws_security_group_rule" "external_alb_http" {
  description       = "This rule allow traffic from internet on 80"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.external_alb.sg_id
}
resource "aws_security_group_rule" "external_alb_https" {
  description       = "This rule allow traffic from internet on 443"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.external_alb.sg_id
}