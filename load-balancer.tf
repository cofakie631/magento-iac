#data "aws_acm_certificate" "certificate" {
#    domain = "magento.letsserveitnow.com"
#    types = ["AMAZON_ISSUED"]
#    most_recent = true
#}

# import the certificate using
#terraform import arn:aws:...
resource "aws_acm_certificate" "cert" {
}


resource "aws_lb" "magento-loadb" {
    name = "magento-loadb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.load-balancer-sg.id]
    subnets = [ aws_subnet.public_network1.id , aws_subnet.public_network2.id ]
  

    enable_deletion_protection = true

}

#Add target groups
resource "aws_lb_target_group" "magento-tg" {
  name     = "magento-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
}

resource "aws_lb_target_group" "varnish-tg" {
  name     = "varnish-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
}


#Add the 2 listeners
resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.magento-loadb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "magento-lb-listener" {
    load_balancer_arn = aws_lb.magento-loadb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = aws_acm_certificate.cert.arn

    default_action {
      type = "forward"

      forward {
        target_group {
            arn = aws_lb_target_group.magento-tg.arn
        }

        target_group {
            arn = aws_lb_target_group.varnish-tg.arn
        }
    }
 }
}

#resource "aws_lb_listener_certificate" "cert" {
#    listener_arn = aws_lb_listener.magento-lb-listener.arn
#    certificate_arn = aws_acm_certificate.cert.arn
#}



resource "aws_lb_listener_rule" "magento-lb-listener-rule" {
  listener_arn = aws_lb_listener.magento-lb-listener.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.magento-tg.arn
  }

  condition {
    path_pattern {
      values = ["/static/*", "/media/*"]
    }
  }

}
