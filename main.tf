resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_D2_v2"
    enable_auto_scaling = "true"
    max_count           = 3
    min_count           = 1
  }

  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "/subscriptions/8e485c9b-6527-441b-a8c3-51058f8daf6e/resourcegroups/rg-cmp-monitor/providers/microsoft.operationalinsights/workspaces/cmp-log-analytics-workspace"
    }
  }
  tags = {
    Environment = "Production"
    Owner       = "CMP"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw
}
