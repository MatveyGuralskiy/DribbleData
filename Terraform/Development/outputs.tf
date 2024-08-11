#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

output "VPC_ID" {
  value       = module.EKS-VPC-Development.VPC_ID
  description = "My VPC ID"
}

output "Public_A_ID" {
  value       = module.EKS-VPC-Development.Public_A_ID
  description = "Public Subnet A ID of VPC"
}

output "Public_B_ID" {
  value       = module.EKS-VPC-Development.Public_B_ID
  description = "Public Subnet B ID of VPC"
}

output "Private_A_ID" {
  value       = module.EKS-VPC-Development.Private_A_ID
  description = "Private Subnet A ID of VPC"
}

output "Private_B_ID" {
  value       = module.EKS-VPC-Development.Private_B_ID
  description = "Private Subnet B ID of VPC"
}

output "SSL_ARN" {
  value       = aws_acm_certificate.DribbleData_cert.arn
  description = "Certificate SSL ARN"
}
