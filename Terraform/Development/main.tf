#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
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

module "EKS-VPC-Development" {
  // source = "OR URL"
  source             = "../Modules/EKS-VPC-Module"
  Environment        = "Development"
  VPC_CIDR           = "192.168.0.0/16"
  Public_A_CIDR      = "192.168.1.0/24"
  Public_B_CIDR      = "192.168.2.0/24"
  Private_A_CIDR     = "192.168.3.0/24"
  Private_B_CIDR     = "192.168.4.0/24"
  Key_SSH            = "Virginia"
  EKS_Name           = "EKS-Development"
  Node_Group_Name    = "Node-Group-Development"
  Scaling_Number     = "4"
  Scaling_Max_Number = "6"
  Instance_type      = "t3.medium"
  EKS_Template_Name  = "EKS-Template-Development"
}

#------------Route53 DNS and ACM-----------------

# Create ACM Request
resource "aws_acm_certificate" "DribbleData_cert" {
  domain_name       = "dev.matveyguralskiy.com"
  validation_method = "DNS"
}

# Route53 Zone information
data "aws_route53_zone" "Application_Zone" {
  name         = "matveyguralskiy.com"
  private_zone = false
}

# Create DNS Record in Route53
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

# DNS Validation of ACM
resource "aws_acm_certificate_validation" "DribbleData_cert_validation" {
  certificate_arn         = aws_acm_certificate.DribbleData_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.DribbleData_cert_validation : record.fqdn]
}
