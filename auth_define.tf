resource "azuread_application" "Terraform" {
  display_name = "Terraform"

  # https://github.com/logos
  logo_image = filebase64("./GitHub-Mark.png")
}

resource "azuread_application_password" "default" {
  application_object_id = azuread_application.Terraform.object_id
}

resource "azuread_service_principal" "default" {
  application_id = azuread_application.Terraform.application_id
}

data "azurerm_subscription" "Student" {}

# https://github.com/hashicorp/terraform-provider-azuread/issues/40
resource "azurerm_role_assignment" "main" {
  scope                = data.azurerm_subscription.Student.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.default.id
}
