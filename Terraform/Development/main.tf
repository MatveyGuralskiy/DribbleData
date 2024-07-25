#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

# Create VPC for Development
provider "aws" {
  region = var.Region
}

# Remote State sends on S3 Bucket
terraform {
  backend "s3" {
    bucket  = "dribbledata-project-remote"
    key     = "Development/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

module "Network_Development" {
  // source = "../AWS_VPC"
  source         = "../VPC-Module"
  Environment    = "Development"
  VPC_CIDR       = "192.168.0.0/16"
  Public_A_CIDR  = "192.168.1.0/24"
  Private_A_CIDR = "192.168.2.0/24"
  Private_B_CIDR = "192.168.3.0/24"
}
