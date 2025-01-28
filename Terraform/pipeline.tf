resource "aws_iam_role_policy_attachment" "pipeline_role_policy_attachment" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = aws_iam_policy.pipeline_policy.arn
}

# S3-bucket för framtida pipeline-artefakter
resource "aws_s3_bucket" "pipeline_artifacts_bucket" {
  bucket = var.artifact_bucket_name
  force_destroy = true
}

resource "aws_codecommit_repository" "my_repo" {
  repository_name = var.repo_name
  description     = "My repository for CodePipeline"
}

### CodePipeline Konfiguration ###
resource "aws_codepipeline" "ecs_pipeline" {
  name = "ecs-deployment-pipeline"

  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.pipeline_artifacts_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = var.repo_name
        BranchName       = "main"  
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.ecs_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "ECS"
      version          = "1"
      input_artifacts  = ["BuildArtifact"]

      configuration = {
        ClusterName        = aws_ecs_cluster.my_ecs_cluster.name
        ServiceName        = aws_ecs_service.my_service.name
        FileName           = "imagedefinitions.json"
      }
    }
  }
}
