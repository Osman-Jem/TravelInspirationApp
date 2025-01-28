# AWS-region
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1" // Ireland
}

# Account ID
variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = "654654539342"
}

variable "artifact_bucket_name" {
  description = "The name of the S3 bucket for pipeline artifacts"
  type        = string
  default     = "ecs-pipeline-artifacts-bucket"
}

# VPC ID
variable "vpc_id" {
  description = "The ID of the VPC where ECS tasks will run"
  type        = string
  default     = "vpc-0ccf2e3e541c79b25"
}

# Subnet IDs
variable "subnet_id" {
  description = "The ID of the subnets"
  type        = list(string)
  default     = ["subnet-0f3c19fd3d0e9a442", "subnet-06b74387413fbd75a", "subnet-0ffed62a456235ffb"]
}

# ECR Repository name
variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "travelinspirationapp-img"
}

# Image URL
variable "my_image_url" {
  description = "The URL of the image to deploy"
  type        = string
  default     = "osmanjem/travelinspirationapp" # Ändra detta eventuellt
}

# Repository name
variable "repo_name" {
  description = "The name of the GitHub/CodeCommit repository"
  type        = string
  default     = "TravelInspirationApp" # Ändra detta eventuellt
}

# ECS Cluster name
variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
  default     = "travelinspiration-cluster"
}

variable "desired_count" {
  description = "The number of tasks to run"
  type        = number
  default     = 1
}

# Task definition CPU
variable "ecs_task_cpu" {
  description = "The CPU requirements for the ECS task"
  type        = string
  default     = "256"
}

# Task definition memory
variable "ecs_task_memory" {
  description = "The memory requirements for the ECS task"
  type        = string
  default     = "512"
}

# IAM Role name
variable "iam_role_name" {
  description = "The name of the ECS IAM role"
  type        = string
  default     = "ecs-execution-role"
} 