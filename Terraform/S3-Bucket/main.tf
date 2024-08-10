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
        Sid       = "AllowPublicRead",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.Bucket_Project.id}/*"
      },
      {
        Sid       = "AllowS3Actions",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
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

#-----------------Static Files of Microservices------------------

resource "aws_s3_object" "main_css" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/main/css/style.css"
  source       = "../../Static/main/static/CSS/style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "main_js" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/main/js/script.js"
  source       = "../../Static/main/static/JavaScript/script.js"
  content_type = "application/javascript"
}

resource "aws_s3_object" "players_css" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/players/css/style.css"
  source       = "../../Static/players/static/CSS/style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "training_css" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/training/css/style.css"
  source       = "../../Static/training/static/CSS/style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "training_js" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/training/js/script.js"
  source       = "../../Static/training/static/JavaScript/script.js"
  content_type = "application/javascript"
}

resource "aws_s3_object" "users_chat_css" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/users/css/chat.css"
  source       = "../../Static/users/static/CSS/chat.css"
  content_type = "text/css"
}

resource "aws_s3_object" "users_chat_js" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/users/js/chat.js"
  source       = "../../Static/users/static/JavaScript/chat.js"
  content_type = "application/javascript"
}

resource "aws_s3_object" "users_js" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/users/js/script.js"
  source       = "../../Static/users/static/JavaScript/script.js"
  content_type = "application/javascript"
}

#Also for Login Page
resource "aws_s3_object" "users_css" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/users/css/style.css"
  source       = "../../Static/users/static/CSS/style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "users_login_js" {
  provider     = aws
  bucket       = aws_s3_bucket.Bucket_Project.id
  key          = "Application/users/js/login.js"
  source       = "../../Static/users/static/JavaScript/login.js"
  content_type = "application/javascript"
}

#CloudFront

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${aws_s3_bucket.Bucket_Project.bucket}.s3.amazonaws.com"

    origin_id = aws_s3_bucket.Bucket_Project.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.Bucket_Project.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront distribution for my microservices"

  price_class = "PriceClass_100" #Only in Europe, USA and Canada

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_cors_configuration" "Bucket_Cors" {
  bucket = aws_s3_bucket.Bucket_Project.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}
