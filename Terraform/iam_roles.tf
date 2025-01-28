# Pipeline IAM Role
resource "aws_iam_role" "pipeline_role" {
  name = "ecs-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Pipeline Policy
resource "aws_iam_policy" "pipeline_policy" {
  name        = "ecs-pipeline-policy"
  description = "Policy for ECS pipeline"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # CodeCommit permissions
      {
        Effect   = "Allow"
        Action   = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive",
          "codecommit:CancelUploadArchive",
          "codecommit:GitPull"
        ]
        Resource = "arn:aws:codecommit:${var.region}:${var.account_id}:${var.repo_name}"
      },
      # CodeBuild permissions
      {
        Effect   = "Allow"
        Action   = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects"
        ]
        Resource = "arn:aws:codebuild:${var.region}:${var.account_id}:*"
      },
      # ECS permissions
      {
        Effect   = "Allow"
        Action   = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:UpdateService",
          "ecs:ListTasks",
          "ecs:StopTask",
          "ecs:RegisterTaskDefinition"
        ]
        Resource = "*"
      },
      # ECR permissions (for source stage)
      {
        Effect   = "Allow"
        Action   = [
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Resource = "arn:aws:ecr:${var.region}:${var.account_id}:repository/${var.ecr_repository_name}"
      },
      # IAM PassRole
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "*"
      },
      # S3 permissions (bucket + objects)
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket_name}"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket_name}/*"
      },
      # CloudWatch Logs permissions
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Pipeline Role
resource "aws_iam_role_policy_attachment" "attach_pipeline_policy" {
  policy_arn = aws_iam_policy.pipeline_policy.arn
  role       = aws_iam_role.pipeline_role.name
}

# CodeBuild IAM Role
resource "aws_iam_role" "codebuild_role" {
  name = "ecs-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# CodeBuild Policy
resource "aws_iam_policy" "codebuild_policy" {
  name        = "ecs-codebuild-policy"
  description = "Policy for CodeBuild to interact with ECR, S3, ECS, and CodeCommit"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR permissions (push/pull images)
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      },
      # S3 permissions
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.artifact_bucket_name}/*"
      },
      # CodeCommit permissions
      {
        Effect   = "Allow"
        Action   = [
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GitPull"
        ]
        Resource = "arn:aws:codecommit:${var.region}:${var.account_id}:${var.repo_name}"
      },
      # CloudWatch Logs permissions
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      # ECS permissions
      {
        Effect   = "Allow"
        Action   = [
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeClusters",
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ]
        Resource = "*"
      },
      # IAM PassRole
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to CodeBuild Role
resource "aws_iam_role_policy_attachment" "attach_codebuild_policy" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuild_role.name
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ECS Task Execution Policy
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecs-task-execution-policy"
  description = "Policy for ECS tasks to pull images and send logs"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR permissions
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "*"
      },
      # CloudWatch Logs permissions
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach ECS Task Execution Policy to ECS Role
resource "aws_iam_role_policy_attachment" "attach_ecs_task_execution_policy" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}