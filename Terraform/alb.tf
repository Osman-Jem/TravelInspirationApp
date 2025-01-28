# 1. Skapa Security Group för ALB
resource "aws_security_group" "alb_security_group" {
  name        = "alb-security-group"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Tillåter all trafik på HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Tillåter all utgående trafik
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SecurityGroup"
  }
}

# 2. Skapa själva ALB
resource "aws_lb" "my_alb" {
  name               = "travelinspiration-alb"
  internal           = false # Gör ALB tillgängligt externt
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = var.subnet_id

  enable_deletion_protection = false

  tags = {
    Name = "TravelInspirationALB"
  }
}

# 3. Skapa Target Group
resource "aws_lb_target_group" "my_target_group" {
  name        = "travelinspiration-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# 4. Skapa Listener för ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}
