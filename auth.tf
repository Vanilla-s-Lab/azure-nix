resource "azuread_application" "example" {
  display_name = "example"
}

resource "azuread_application_password" "example" {
  application_object_id = azuread_application.example.object_id
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}

data "azurerm_subscription" "Student" {}

# https://github.com/hashicorp/terraform-provider-azuread/issues/40
resource "azurerm_role_assignment" "main" {
  scope                = data.azurerm_subscription.Student.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.id
}
