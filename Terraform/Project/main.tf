#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

# Create VPC for Development
provider "aws" {
  region = var.Region_USA
}

# Remote State sends on S3 Bucket
terraform {
  backend "s3" {
    bucket  = "dribbledata-project-remote-state"
    key     = "Development/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "EKS-VPC-DribbleData" {
  // source = "OR URL"
  source             = "../Modules/EKS-VPC-Module"
  Environment        = "Production"
  VPC_CIDR           = "192.168.0.0/16"
  Public_A_CIDR      = "192.168.1.0/24"
  Public_B_CIDR      = "192.168.2.0/24"
  Private_A_CIDR     = "192.168.3.0/24"
  Private_B_CIDR     = "192.168.4.0/24"
  Key_SSH            = "Virginia"
  EKS_Name           = "EKS-Dribbledata"
  Node_Group_Name    = "Node-Group-Dribbledata"
  Scaling_Number     = "4"
  Scaling_Max_Number = "6"
  Instance_type      = "t3.medium"
  EKS_Template_Name  = "EKS-Template-Dribbledata"
}

#------------Route53 DNS and ACM-----------------

# Create ACM Request for Application
resource "aws_acm_certificate" "DribbleData_cert" {
  domain_name       = "dribbledata.matveyguralskiy.com"
  validation_method = "DNS"
}

# Route53 Zone information
data "aws_route53_zone" "Application_Zone" {
  name         = "matveyguralskiy.com"
  private_zone = false
}

# Create DNS Record in Route53 for Application
resource "aws_route53_record" "DribbleData_cert_validation" {
  # Dynamic Record
  for_each = {
    # Domain Validation Option for ACM
    for dvo in aws_acm_certificate.DribbleData_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.Application_Zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# DNS Validation of ACM for Application
resource "aws_acm_certificate_validation" "DribbleData_cert_validation" {
  certificate_arn         = aws_acm_certificate.DribbleData_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.DribbleData_cert_validation : record.fqdn]
}

# Create ACM Request for Prometheus
resource "aws_acm_certificate" "DribbleData_cert_Prometheus" {
  domain_name       = "prometheus.matveyguralskiy.com"
  validation_method = "DNS"
}

# Create DNS Record in Route53 for Prometheus
resource "aws_route53_record" "DribbleData_cert_validation_Prometheus" {
  # Dynamic Record
  for_each = {
    # Domain Validation Option for ACM
    for dvo in aws_acm_certificate.DribbleData_cert_Prometheus.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.Application_Zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# DNS Validation of ACM for Prometheus
resource "aws_acm_certificate_validation" "DribbleData_cert_validation_Prometheus" {
  certificate_arn         = aws_acm_certificate.DribbleData_cert_Prometheus.arn
  validation_record_fqdns = [for record in aws_route53_record.DribbleData_cert_validation_Prometheus : record.fqdn]
}

# Create ACM Request for Grafana
resource "aws_acm_certificate" "DribbleData_cert_Grafana" {
  domain_name       = "grafana.matveyguralskiy.com"
  validation_method = "DNS"
}

# Create DNS Record in Route53 for Grafana
resource "aws_route53_record" "DribbleData_cert_validation_Grafana" {
  # Dynamic Record
  for_each = {
    # Domain Validation Option for ACM
    for dvo in aws_acm_certificate.DribbleData_cert_Grafana.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.Application_Zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# DNS Validation of ACM for Grafana
resource "aws_acm_certificate_validation" "DribbleData_cert_validation_Grafana" {
  certificate_arn         = aws_acm_certificate.DribbleData_cert_Grafana.arn
  validation_record_fqdns = [for record in aws_route53_record.DribbleData_cert_validation_Grafana : record.fqdn]
}

#-----------------------AWS Backup---------------------------

# Remote State of Development Terraform files
data "terraform_remote_state" "remote_state" {
  backend = "s3"

  config = {
    bucket  = "dribbledata-project-remote-state"
    key     = "Database/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

# IAM role for Backup
resource "aws_iam_role" "Backup_role" {
  name = "backup-role-dribbledata"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Backup
resource "aws_iam_role_policy" "Backup_policy" {
  name = "backup-policy"
  role = aws_iam_role.Backup_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "backup:StartBackupJob",
          "backup:StopBackupJob",
          "backup:ListBackupJobs",
          "backup:GetBackupPlan",
          "backup:GetBackupSelection",
          "backup:ListBackupPlans",
          "backup:ListBackupSelections"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:ListTables",
          "dynamodb:DescribeTable"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "*"
      }
    ]
  })
}

# Backup Vault
resource "aws_backup_vault" "Vault_dribbledata" {
  name = "backup-vault"
}

# Backup Plan
resource "aws_backup_plan" "Backup_plan_dribbledata" {
  name = "backup-plan-dribbledata"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.Vault_dribbledata.name
    schedule          = "cron(0 12 * * ? *)" # Every day at 12 UTC
    lifecycle {
      delete_after = 30 # Save copies for 30 days
    }
  }
}

# Resources to Backup
resource "aws_backup_selection" "Backup_selection" {
  iam_role_arn = aws_iam_role.Backup_role.arn
  name         = "backup-selection"
  plan_id      = aws_backup_plan.Backup_plan_dribbledata.id

  resources = [
    data.terraform_remote_state.remote_state.outputs.DynamoDB_Table_Users_ARN,
    data.terraform_remote_state.remote_state.outputs.DynamoDB_Table_Messages_ARN,
    data.terraform_remote_state.remote_state.outputs.DynamoDB_Table_Players_ARN,
    var.S3_Bucket_ARN
  ]
}

#-----------------------Lambda---------------------------


# IAM Role for Lambda
resource "aws_iam_role" "Lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "Lambda_policy" {
  name        = "lambda_policy"
  description = "Policy for Lambda function to access EC2 and SSM"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ssm:SendCommand"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "Lambda_policy_attachment" {
  role       = aws_iam_role.Lambda_role.name
  policy_arn = aws_iam_policy.Lambda_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "Update_packages" {
  filename      = "lambda_function.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.Lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      CLUSTER_NAME   = "EKS-Dribbledata"
      NODEGROUP_NAME = "Node-Group-Dribbledata"
    }
  }
}

# Lambda Permissions for SSM
resource "aws_lambda_permission" "Allow_ssm" {
  statement_id  = "AllowSSMInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Update_packages.function_name
  principal     = "ssm.amazonaws.com"
}

# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ssm.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for SSM
resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm_policy"
  description = "Policy for SSM to interact with Lambda"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = aws_lambda_function.Update_packages.arn
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

# CloudWatch Event Rule to Trigger Lambda
resource "aws_cloudwatch_event_rule" "rule" {
  name                = "daily_update_check"
  description         = "Trigger Lambda function daily to check for updates"
  schedule_expression = "rate(1 day)"
}

# Lambda Target for CloudWatch Event
resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.rule.name
  target_id = "update_packages"
  arn       = aws_lambda_function.Update_packages.arn
}

# IAM Policy to Allow CloudWatch Events to Invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatchInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Update_packages.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule.arn
}

#---------------------------CloudWatch Logs--------------------------------

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = "EKS-Dribbledata"
}

# Extract the OIDC provider ID from the EKS cluster's OIDC issuer URL
locals {
  oidc_provider_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  oidc_provider_id = element(
    split("/", local.oidc_provider_url),
    4
  )
}

# Create IAM Role for Fluent Bit
resource "aws_iam_role" "fluent_bit_role" {
  name = "FluentBitRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${local.oidc_provider_id}"
        },
        Action = "sts:AssumeRoleWithWebIdentity"
      }
    ]
  })
  depends_on = [module.EKS-VPC-DribbleData]
}

# Create IAM Policy for Fluent Bit
resource "aws_iam_policy" "fluent_bit_policy" {
  name = "fluent_bit_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "eks:DescribeCluster"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "fluent_bit_policy_attachment" {
  role       = aws_iam_role.fluent_bit_role.name
  policy_arn = aws_iam_policy.fluent_bit_policy.arn
}
