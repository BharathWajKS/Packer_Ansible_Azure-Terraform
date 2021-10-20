resource "azurerm_resource_group" "resource_group" {
  name     = "Clarium-resources"
  location = "East US"
}

resource "azurerm_shared_image_gallery" "shared_image_gallery" {
  name                = "Clariun_image_gallery"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  description         = "Shared images"

  tags = {
    Hello = "There"
    World = "Example"
  }
}

resource "azurerm_shared_image" "shared_image" {
  name                = "Clarium-image"
  gallery_name        = azurerm_shared_image_gallery.shared_image_gallery.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Linux"

  identifier {
    publisher = "PublisherName"
    offer     = "OfferName"
    sku       = "ExampleSku"
  }
}
