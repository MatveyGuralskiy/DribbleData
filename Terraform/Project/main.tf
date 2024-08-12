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

# Lambda IAM Role
resource "aws_iam_role" "Lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ],
  })
}

# Lambda Policy
resource "aws_iam_policy" "Lambda_policy" {
  name = "lambda_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "eks:UpdateNodegroupConfig",
          "eks:DescribeNodegroup",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:RebootInstances"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Lambda_policy_attachment" {
  role       = aws_iam_role.Lambda_role.name
  policy_arn = aws_iam_policy.Lambda_policy.arn
}

resource "aws_lambda_function" "Lambda_function_updates" {
  filename      = "lambda_function.zip"
  function_name = "eks_node_update_function"
  role          = aws_iam_role.Lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      CLUSTER_NAME   = "EKS-Dribbledata"
      NODEGROUP_NAME = "Node-Group-Dribbledata"
    }
  }

  source_code_hash = filebase64sha256("lambda_function.zip")
}

# CloudWatch for Lambda

# Rule to run every 24 hours
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "eks-update-schedule"
  schedule_expression = "rate(24 hours)"
}

# Lambda Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule = aws_cloudwatch_event_rule.schedule.name
  arn  = aws_lambda_function.Lambda_function_updates.arn
}

# Permissions for CloudWatch
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_function_updates.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

#---------------------------CloudWatch Logs--------------------------------

# Send Logs to CloudWatch Logs with Fluent Bit

# Create Role for Fluent Bit
resource "aws_iam_role" "fluent_bit_role" {
  name = "fluent_bit_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Create Policy for Fluent Bit
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
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "fluent_bit_policy_attachment" {
  role       = aws_iam_role.fluent_bit_role.name
  policy_arn = aws_iam_policy.fluent_bit_policy.arn
}
