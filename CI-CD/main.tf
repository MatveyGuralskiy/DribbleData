provider "aws" {
  region = var.Region
}

variable "project_name" {
  default = "CodeBuild-Test"
}

variable "Region" {
  default = "us-east-1"
}

# Объявляем идентификатор аккаунта
data "aws_caller_identity" "current" {}

resource "aws_codebuild_project" "CodeBuild" {
  name          = var.Project_name
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
      value = var.Region
    }
    environment_variable {
      name  = "REPOSITORY_URI"
      value = "public.ecr.aws/v7s8q4q5/microservice-test"
    }
    environment_variable {
      name  = "APP_VERSION"
      value = "V1.0"
    }
    environment_variable {
      name  = "SECRET_KEY"
      value = data.aws_ssm_parameter.secret_key.value
    }
    environment_variable {
      name  = "SESSION_COOKIE_SECURE"
      value = data.aws_ssm_parameter.session_cookie_secure.value
    }
    environment_variable {
      name  = "SESSION_COOKIE_HTTPONLY"
      value = data.aws_ssm_parameter.session_cookie_httponly.value
    }
    environment_variable {
      name  = "SESSION_COOKIE_SAMESITE"
      value = data.aws_ssm_parameter.session_cookie_samesite.value
    }
    environment_variable {
      name  = "DAX_ENDPOINT"
      value = data.aws_ssm_parameter.dax_endpoint.value
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.Project_name}"
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

# SSM Policy
resource "aws_iam_policy" "codebuild_ssm_policy" {
  name        = "CodeBuildSSMPolicy"
  description = "Policy to allow CodeBuild to access SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.Region}:${data.aws_caller_identity.current.account_id}:parameter/dribble-data/*"
      }
    ]
  })
}

# ECR Policy
resource "aws_iam_policy" "codebuild_ecr_policy" {
  name = "codebuild-ecr-policy"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policies to the role
resource "aws_iam_role_policy_attachment" "codebuild_ssm_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_ecr_policy.arn
}

# SSM Parameters
data "aws_ssm_parameter" "secret_key" {
  name = "/dribble-data/SECRET_KEY"
}

data "aws_ssm_parameter" "session_cookie_secure" {
  name = "/dribble-data/SESSION_COOKIE_SECURE"
}

data "aws_ssm_parameter" "session_cookie_httponly" {
  name = "/dribble-data/SESSION_COOKIE_HTTPONLY"
}

data "aws_ssm_parameter" "session_cookie_samesite" {
  name = "/dribble-data/SESSION_COOKIE_SAMESITE"
}

data "aws_ssm_parameter" "dax_endpoint" {
  name = "/dribble-data/DAX_ENDPOINT"
}
