output "private_ip" {
  description = "IP address of the cluster"
  value       = terraform_data.default.output.private_ip
}

output "public_ip" {
  description = "Public IP address of the cluster"
  value       = terraform_data.default.output.public_ip
}

output "device" {
  description = "Default network device of the cluster"
  value       = terraform_data.default.output.device
}

output "name" {
  description = "Name of the cluster host"
  value       = terraform_data.default.output.name
}

output "ips" {
  description = "IP addresses of the cluster"
  value       = terraform_data.default.output.ips
}

output "os" {
  description = "Operating system of the cluster"
  value       = terraform_data.default.output.os
}
