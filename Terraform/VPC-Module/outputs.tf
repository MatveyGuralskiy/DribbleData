#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

output "VPC_ID" {
  value       = aws_vpc.VPC.id
  description = "My VPC ID"
}

output "VPC_CIDR" {
  value       = aws_vpc.VPC.cidr_block
  description = "My VPC CIDR Block"
}

output "Public_A_ID" {
  value       = aws_subnet.Public_A.id
  description = "Public Subnets ID of VPC"
}
