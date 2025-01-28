resource "aws_iam_role_policy_attachment" "codebuild_role_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "codebuild_s3_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_codebuild_project" "ecs_build" {
  name          = "ecs-build"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true # Vilket krävs för att kunna bygga Docker-images

    environment_variable {
      name  = "REPOSITORY_URI"
      value = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository_name}"
    }
    
    environment_variable {
      name  = "AWS_DEFAULT_REGION"  # Required for AWS CLI
      value = var.region
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("../buildspec.yml") # Eftersom filen ligger utanför mappen där Terraform körs
  }
}
