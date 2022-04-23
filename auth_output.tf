# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

output "ARM_CLIENT_ID" {
  value     = azuread_application.Terraform.application_id
  sensitive = true
}

output "ARM_CLIENT_SECRET" {
  value     = azuread_application_password.default.value
  sensitive = true
}

output "ARM_TENANT_ID" {
  value     = azuread_service_principal.default.application_tenant_id
  sensitive = true
}

# az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID

output "ARM_SUBSCRIPTION_ID" {
  value     = data.azurerm_subscription.Student.subscription_id
  sensitive = true
}
