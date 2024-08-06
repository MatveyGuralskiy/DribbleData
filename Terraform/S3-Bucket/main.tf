#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

provider "aws" {
  region = var.Region_USA
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
  provider = aws
  bucket   = var.Remote_State_S3_Remote
  tags = {
    Name = "Terraform Remote State - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning_Remote" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Remote.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption_Remote" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Remote.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create S3 Bucket for Project
resource "aws_s3_bucket" "Bucket_Project" {
  provider = aws
  bucket   = var.Remote_State_S3_Project

  tags = {
    Name = "Project - S3 Bucket"
  }
}

# Attach versioning to the Bucket
resource "aws_s3_bucket_versioning" "Bucket_Versioning_Project" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Attach Encryption to the Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "Bucket_Encryption_Project" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "Bucket_Public_Access_Block" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "Bucket_Policy" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowS3Actions",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.Bucket_Project.id}/*"
      }
    ]
  })
}

resource "aws_s3_object" "image_1" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  key      = "logo.png"
  source   = "../../Screens/S3-Bucket/Icon.png"
}

resource "aws_s3_object" "image_2" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  key      = "main-image.png"
  source   = "../../Screens/S3-Bucket/Logo-Project.png"
}

resource "aws_s3_object" "video_1" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  key      = "video1.mp4"
  source   = "../../Screens/S3-Bucket/video1.mp4"
}

resource "aws_s3_object" "video_2" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  key      = "video2.mp4"
  source   = "../../Screens/S3-Bucket/video2.mp4"
}

resource "aws_s3_object" "video_3" {
  provider = aws
  bucket   = aws_s3_bucket.Bucket_Project.id
  key      = "video3.mp4"
  source   = "../../Screens/S3-Bucket/video3.mp4"
}
