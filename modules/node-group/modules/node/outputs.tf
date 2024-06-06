output "cloud_init_config" {
  value = terraform_data.cloud_init.output.user_data
}
