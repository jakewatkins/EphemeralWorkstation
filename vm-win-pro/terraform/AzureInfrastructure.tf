#Azure infrastructure

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "rg" {
  name     = "${var.rgName}${var.nameBase}"
  location = "${var.azRegion}"
}

## <https://www.terraform.io/docs/providers/azurerm/r/availability_set.html>
resource "azurerm_availability_set" "asetSprint" {
  name                = "${var.AvailabilitySetName}${var.nameBase}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}


