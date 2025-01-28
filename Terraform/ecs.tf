# Data för att hämta AWS-kontots ID
data "aws_caller_identity" "current" {}

# 1. Skapar ECS Cluster
resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = var.ecs_cluster_name
}

# 2. CloudWatch Log Group för ECS Task Definition loggar
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/travelinspiration"
  retention_in_days = 7 # Behåll loggar i 7 dagar
}

# 3. Definiera ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = "travelinspiration-task" # Namnet för min Task Definition
  network_mode             = "awsvpc"      # Använder VPC-nätverk
  requires_compatibilities = ["FARGATE"]  # ECS Fargate för serverless containers för att inte behöva hantera instanser
  cpu                      = var.ecs_task_cpu  
  memory                   = var.ecs_task_memory  
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  # Container definition
  container_definitions = jsonencode([{
      name      = "travelinspiration-container"
      image     = "${var.my_image_url}:latest" # Image URL från ECR eller Docker Hub
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
      logConfiguration = { # Lägger till log-konfiguration för CloudWatch
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/travelinspiration" # Log Group för applikationen
          awslogs-region        = var.region             # Region där loggen kommer sparas
          awslogs-stream-prefix = "ecs"                  # Prefix för log-stream
        }
      }
    }
  ])
}

# 4. Skapa ECS Service som använder Task Definition
resource "aws_ecs_service" "my_service" {
  name            = "travelinspiration-service"
  cluster         = aws_ecs_cluster.my_ecs_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_id
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }

  desired_count = var.desired_count # Antal instanser av containern som ska köras (just nu)

  # Lägg till load balancer-konfiguration
  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "travelinspiration-container"
    container_port   = 5000
  }

  tags = {
    Name = "TravelECSService"
  }
}

# 5. IAM Execution Role för ECS att dra från ECR
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 6. CloudWatch-loggpolicy för IAM Execution Role
resource "aws_iam_role_policy" "ecs_cloudwatch_log_policy" {
  name = "ecs-cloudwatch-log-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/travelinspiration:*"
      }
    ]
  })
}
