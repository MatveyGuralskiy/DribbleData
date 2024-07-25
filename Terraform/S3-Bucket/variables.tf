#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

variable "Region_GER" {
  description = "AWS Region to work with Germany"
  type        = string
  default     = "eu-central-1"
}

variable "Remote_State_S3_Remote" {
  description = "Terraform Backend Bucket Name"
  type        = string
  default     = "dribbledata-project-remote"
}

variable "Remote_State_S3_Project" {
  description = "Terraform Backend Bucket Name for Production"
  type        = string
  default     = "dribbledata-project-project"
}
