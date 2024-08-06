provider "aws" {
  region = "us-east-1"
}

variable "project_name" {
  default = "CodeBuild-Test"
}

resource "aws_codebuild_project" "CodeBuild" {
  name          = var.project_name
  description   = "My CodeBuild project"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  source {
    type     = "GITHUB"
    location = "https://github.com/MatveyGuralskiy/DribbleData.git"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }
    environment_variable {
      name  = "REPOSITORY_URI"
      value = "public.ecr.aws/v7s8q4q5/microservice-test"
    }
    environment_variable {
      name  = "APP_VERSION"
      value = "V1.0"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}"
      stream_name = "log-stream"
    }
  }

  cache {
    type = "NO_CACHE"
  }

  tags = {
    Name = "MyCodeBuildProject"
  }
}


resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_cloudwatch_policy" {
  name = "codebuild-cloudwatch-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}
