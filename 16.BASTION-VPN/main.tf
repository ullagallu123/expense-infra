locals {
  vpn_sg_id        = data.aws_ssm_parameter.vpn_sg_id.value
  bastion_sg_id    = data.aws_ssm_parameter.bastion_sg_id.value
  public_subnet_id = element(split(",", data.aws_ssm_parameter.public_subnets.value), 0)
  ami_bastion      = data.aws_ami.amz3.id
  ami_vpn          = data.aws_ami.openvpn.id
  name             = "${var.project_name}-${var.environment}"
}

module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${local.name}-bastion"
  ami                    = local.ami_bastion
  instance_type          = "t2.micro"
  key_name               = "siva"
  vpc_security_group_ids = ["${local.bastion_sg_id}"]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-bastion"
    }
  )

}

module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                   = "${local.name}-vpn"
  ami                    = local.ami_vpn
  instance_type          = "t3a.small"
  key_name               = "siva"
  vpc_security_group_ids = ["${local.vpn_sg_id}"]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-vpn"
    }
  )

}