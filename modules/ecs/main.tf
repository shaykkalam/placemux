# 1. Create a Private Container Registry (Like Docker Hub, but secure on AWS)
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.env_name}-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # Automatically scans your Docker containers for safety bugs
  }
}

# 2. Create the Managed Container Runtime Cluster
resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.env_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled" # Turns on basic performance telemetry tracking
  }
}