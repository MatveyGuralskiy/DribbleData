#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

#-----------------VPC-----------------------

variable "Region" {
  description = "AWS Region to work with"
  type        = string
  default     = "us-east-1"
}

variable "Environment" {
  description = "Environment for the Project"
  type        = string
  default     = "Development"
}

variable "VPC_CIDR" {
  type        = string
  description = "My CIDR Block of AWS VPC"
  default     = "10.0.0.0/16"
}

variable "Public_A_CIDR" {
  type        = string
  description = "My CIDR Block for Public A Subnet"
  default     = "10.0.1.0/24"
}

variable "Public_B_CIDR" {
  type        = string
  description = "My CIDR Block for Public B Subnet"
  default     = "10.0.2.0/24"
}

variable "Private_A_CIDR" {
  type        = string
  description = "My CIDR Block for Private Subnet A"
  default     = "10.0.3.0/24"
}

variable "Private_B_CIDR" {
  type        = string
  description = "My CIDR Block for Private Subnet B"
  default     = "10.0.4.0/24"
}

#-----------------EKS-----------------------

variable "EKS_Name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "EKS"
}

variable "Node_Group_Name" {
  description = "Node Group Name for Cluster"
  type        = string
  default     = "Node-EKS-Group"

}

variable "Scaling_Number" {
  description = "Node Group Number of Instances"
  type        = string
  default     = "6"
}

variable "Scaling_Max_Number" {
  description = "Node Group Maximum Number of Instances"
  type        = string
  default     = "8"
}

variable "Instance_type" {
  description = "Default Instance Type for Nodes"
  type        = string
  default     = "t3.small"
}

variable "Key_SSH" {
  description = "SSH Keygen for Nodes"
  type        = string
  default     = "Virginia"
}

variable "EKS_Template_Name" {
  description = "EKS Template Name for Node Group Nodes"
  type        = string
  default     = "EKS-Template"
}
