resource "aws_elb" "lamp_lb" {
  subnets         = [data.aws_subnet.def_subnet.id]
  security_groups = [aws_security_group.elb_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  depends_on = [
    aws_acm_certificate.ssl
  ]

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:acm:us-west-2:314615762709:certificate/d144dbe2-d9e7-46b3-9e90-e71860ae0dd6"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}