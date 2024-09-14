locals {
  name            = "${var.project_name}-${var.environment}-external-alb"
  sg_id           = data.aws_ssm_parameter.external_alb_sg_id.value
  private_subnets = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  frontend_sg_id  = data.aws_ssm_parameter.frontend_sg_id.value
  https_arn       = data.aws_ssm_parameter.external_htpps_listner_arn.value
  cw_iam_role = data.aws_iam_instance_profile.ec2_instance_profile.name
}

resource "aws_launch_template" "frontend" {
  name                   = "frontend"
  image_id               = "ami-0b85a91bffe1ea8b8"
  instance_type          = "t2.micro"
  key_name               = "siva"
  iam_instance_profile {
    name = local.cw_iam_role
  }
  vpc_security_group_ids = [local.frontend_sg_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-frontend"
    }
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = "${var.project_name}-${var.environment}-frontend"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns         = [aws_lb_target_group.frontend.arn]
  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
  vpc_zone_identifier = local.private_subnets

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-frontend"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "frontend" {
  name                   = "${var.project_name}-${var.environment}-frontend"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.frontend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

resource "aws_lb_target_group" "frontend" {
  name     = "${var.project_name}-${var.environment}-frontend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = local.https_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
  condition {
    host_header {
      values = ["expense.test.ullagallu.cloud"]
    }
  }
}
