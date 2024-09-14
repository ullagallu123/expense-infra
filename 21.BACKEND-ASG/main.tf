locals {
  name                = "${var.project_name}-${var.environment}-internal-alb"
  sg_id               = data.aws_ssm_parameter.internal_alb_sg_id.value
  private_subnets     = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  backend_listner_arn = data.aws_ssm_parameter.backend_listner_arn.value
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  backend_sg_id       = data.aws_ssm_parameter.backend_id.value
  cw_iam_role = data.aws_iam_instance_profile.ec2_instance_profile.name
}

resource "aws_launch_template" "backend" {
  name                   = "backend"
  image_id               = "ami-025c0bfea2dc4d5a1"
  instance_type          = "t2.micro"
  key_name               = "siva"
  iam_instance_profile {
    name=local.cw_iam_role
  }
  vpc_security_group_ids = [local.backend_sg_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-backend"
    }
  }
}

resource "aws_autoscaling_group" "backend" {
  name                      = "${var.project_name}-${var.environment}-backend"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 1
  target_group_arns         = [aws_lb_target_group.backend.arn]
  launch_template {
    id      = aws_launch_template.backend.id
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
    value               = "${var.project_name}-${var.environment}-backend"
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

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.project_name}-${var.environment}-backend"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backend.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.project_name}-${var.environment}-backend"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = local.backend_listner_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
  condition {
    host_header {
      values = ["backend.test.ullagallu.cloud"]
    }
  }
}

