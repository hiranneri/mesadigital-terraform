# Saída para o ID do Security Group criado
output "security_group_id" {
  description = "ID do Security Group (mesadigital_security_group_pub)"
  value       = aws_security_group.mesadigital_security_group_pub.id
}

# Saída para o ID da VPC
output "vpc_id" {
  description = "ID da VPC (mesadigital_vpc_1)"
  value       = aws_vpc.mesadigital_vpc_1.id
}