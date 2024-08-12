#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

output "VPC_ID" {
  value       = module.EKS-VPC-DribbleData.VPC_ID
  description = "My VPC ID"
}

output "Public_A_ID" {
  value       = module.EKS-VPC-DribbleData.Public_A_ID
  description = "Public Subnet A ID of VPC"
}

output "Public_B_ID" {
  value       = module.EKS-VPC-DribbleData.Public_B_ID
  description = "Public Subnet B ID of VPC"
}

output "SSL_ARN" {
  value       = aws_acm_certificate.DribbleData_cert.arn
  description = "Certificate SSL ARN for Application"
}

output "SSL_ARN_Prometheus" {
  value       = aws_acm_certificate.DribbleData_cert_Prometheus.arn
  description = "Certificate SSL ARN for Prometheus"
}

output "SSL_ARN_Grafana" {
  value       = aws_acm_certificate.DribbleData_cert_Grafana.arn
  description = "Certificate SSL ARN for Grafana"
}
