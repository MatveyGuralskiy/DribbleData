#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

variable "Region_USA" {
  description = "AWS Region to work with USA"
  type        = string
  default     = "us-east-1"
}

variable "Remote_State_S3_Remote" {
  description = "Terraform Backend Bucket Name"
  type        = string
  default     = "dribbledata-project-remote-state"
}

variable "Remote_State_S3_Project" {
  description = "Terraform Backend Bucket Name for Production"
  type        = string
  default     = "dribbledata-project"
}
