locals {
  db_sg_id         = data.aws_ssm_parameter.db_sg_id.value
  name             = "${var.project_name}-${var.environment}"
  db_sg_group_name = data.aws_ssm_parameter.db_subnets_group_name.value
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${local.name}-mysql"



  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name                     = "transactions"
  username                    = "root"
  port                        = "3306"
  family                      = "mysql8.0"
  major_engine_version        = "8.0"
  manage_master_user_password = false
  password                    = "ExpenseApp1"
  db_subnet_group_name        = local.db_sg_group_name
  skip_final_snapshot         = true

  vpc_security_group_ids = ["${local.db_sg_id}"]

  tags = merge(
    {
      Name = "${local.name}-mysql"
    }
  )
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}