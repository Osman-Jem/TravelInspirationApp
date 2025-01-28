# AWS-region
provider "aws" {
  region = var.region # Regionen jag använder är Irland
}

# Skapa ett ECR Repository
resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = var.ecr_repository_name # Namnet på mitt ECR-repo
  force_delete         = true     # Tar bort bilderna när ECR-repot tas bort

  # Kryptering och andra inställningar
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "MyWebApp-ECR"
    Environment = "Production"
  }
}

# Output för att visa repository URL efter skapandet
output "ecr_repository_url" {
  value = aws_ecr_repository.my_ecr_repo.repository_url
}
