# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

output "client_id" {
  value       = azuread_application.example.application_id
  sensitive   = true
  description = "ARM_CLIENT_ID"
}

output "client_secret" {
  value       = azuread_application_password.example.value
  sensitive   = true
  description = "ARM_CLIENT_SECRET"
}

output "tenant_id" {
  value       = azuread_service_principal.example.application_tenant_id
  sensitive   = true
  description = "ARM_TENANT_ID"
}

# az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID

output "ARM_SUBSCRIPTION_ID" {
  value     = data.azurerm_subscription.Student.subscription_id
  sensitive = true
}
