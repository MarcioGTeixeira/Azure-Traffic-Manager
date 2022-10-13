terraform {
  backend "azurerm" {}
}

provider "azurerm" {
    features {}
  
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-trafficmanager-terraform"
  location = "brazilsouth"
}

resource "azurerm_traffic_manager_profile" "trafficprofile" {
  name                   = "trafficmanagerprofile-terraform"
  resource_group_name    = azurerm_resource_group.rg.name
  traffic_routing_method = "Geographic"

  dns_config {
    relative_name = "trafficmanagerrgeo"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 4
  }

} 

// APP PLAN E SERVICE BR
resource "azurerm_service_plan" "planbr" {
    name = "service-plan-br"
    location = "brazilsouth"
    resource_group_name = azurerm_resource_group.rg.name
    os_type = "Windows"
    sku_name = "S1"
  
}

resource "azurerm_windows_web_app" "appservicebr" {
  name                = "appservice-br"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.planbr.location
  service_plan_id     = azurerm_service_plan.planbr.id
  site_config {}
}

// APP PLAN E SERVICE USA
resource "azurerm_service_plan" "planus" {
    name = "service-plan-us"
    location = "eastus"
    resource_group_name = azurerm_resource_group.rg.name
    os_type = "Windows"
    sku_name = "S1"
  
}

resource "azurerm_windows_web_app" "appserviceus" {
  name                = "appservice-us"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.planus.location
  service_plan_id     = azurerm_service_plan.planus.id
  site_config {}
}

// APP PLAN E SERVICE WORLD
resource "azurerm_service_plan" "planworld" {
    name = "service-plan-world"
    location = "uksouth"
    resource_group_name = azurerm_resource_group.rg.name
    os_type = "Windows"
    sku_name = "S1"
  
}

resource "azurerm_windows_web_app" "appserviceworld" {
  name                = "appservice-world"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.planworld.location
  service_plan_id     = azurerm_service_plan.planworld.id
  site_config {}
}

//Endpoints

resource "azurerm_traffic_manager_azure_endpoint" "cdnendpointbr" {
    name = "traffic-br"
    profile_id = azurerm_traffic_manager_profile.trafficprofile.id
    target_resource_id = azurerm_windows_web_app.appservicebr.id
    weight = 100 
    geo_mappings = ["BR"]
  
}

resource "azurerm_traffic_manager_azure_endpoint" "cdnendpointus" {
    name = "traffic-us"
    profile_id = azurerm_traffic_manager_profile.trafficprofile.id
    target_resource_id = azurerm_windows_web_app.appserviceus.id
    weight = 101 
    geo_mappings = ["US"]
}

resource "azurerm_traffic_manager_azure_endpoint" "cdnendpointworld" {
    name = "traffic-world"
    profile_id = azurerm_traffic_manager_profile.trafficprofile.id
    target_resource_id = azurerm_windows_web_app.appserviceworld.id
    weight = 102 
    geo_mappings = ["WORLD"]
}