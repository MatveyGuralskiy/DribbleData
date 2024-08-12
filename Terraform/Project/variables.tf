#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------
variable "Region_USA" {
  description = "Region Germany for Project"
  type        = string
  default     = "us-east-1"
}

variable "S3_Bucket_ARN" {
  description = "S3 Bucket ARN for Backup"
  type        = string
  default     = "arn:aws:s3:::dribbledata-project"
}
