locals {
  name           = "${var.project_name}-${var.environment}-external-alb"
  sg_id          = data.aws_ssm_parameter.external_alb_sg_id.value
  public_subnets = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
}
resource "aws_lb" "test" {
  name                       = local.name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["${local.sg_id}"]
  subnets                    = local.public_subnets
  enable_deletion_protection = false
  tags = merge(
    var.common_tags,
    {
      Name = local.name
  })
}


resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"

  protocol        = "HTTPS"
  certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
  ssl_policy      = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from Web ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}
