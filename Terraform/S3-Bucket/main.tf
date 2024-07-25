#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

provider "aws" {
  region = var.Region_GER
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

#------------Remote state and S3 Bucket-----------------
# Create S3 Bucket for Terraform Remote State
resource "aws_s3_bucket" "Bucket_Remote" {
  bucket = var.Remote_State_S3_Remote

  tags = {
    Name = "Terraform Remote State - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning_Remote" {
  bucket = aws_s3_bucket.Bucket_Remote.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption_Remote" {
  bucket = aws_s3_bucket.Bucket_Remote.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create S3 Bucket for Project
resource "aws_s3_bucket" "Bucket_Project" {
  bucket = var.Remote_State_S3_Project

  tags = {
    Name = "Project - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning_Project" {
  bucket = aws_s3_bucket.Bucket_Project.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption_Project" {
  bucket = aws_s3_bucket.Bucket_Project.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
