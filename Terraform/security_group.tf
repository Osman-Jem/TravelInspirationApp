resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-security-group"
  description = "Allow 5000 traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Tillåter trafik från alla IP-adresser
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Tillåter all utgående trafik
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS-SecurityGroup"
  }
}