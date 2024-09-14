locals {
  name            = "${var.project_name}-${var.environment}-internal-alb"
  sg_id           = data.aws_ssm_parameter.internal_alb_sg_id.value
  private_subnets = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
}
resource "aws_lb" "test" {
  name                       = local.name
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = ["${local.sg_id}"]
  subnets                    = local.private_subnets
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
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Fixed Response From Internal ALB</h1>"
      status_code  = "200"
    }
  }
}