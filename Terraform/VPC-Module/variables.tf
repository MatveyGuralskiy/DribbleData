#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

variable "Region" {
  description = "AWS Region to work with"
  type        = string
  default     = "eu-central-1"
}

variable "Environment" {
  description = "Environment for the Project"
  type        = string
  default     = "Development"
}

variable "VPC_CIDR" {
  type        = string
  description = "My CIDR Block of AWS VPC"
  default     = "192.168.0.0/16"
}

variable "Public_A_CIDR" {
  type        = string
  description = "My CIDR Block for Public Subnet"
  default     = "192.168.1.0/24"
}

variable "Private_A_CIDR" {
  type        = string
  description = "My CIDR Block for Private Subnet A"
  default     = "192.168.2.0/24"
}

variable "Private_B_CIDR" {
  type        = string
  description = "My CIDR Block for Private Subnet B"
  default     = "192.168.3.0/24"
}
