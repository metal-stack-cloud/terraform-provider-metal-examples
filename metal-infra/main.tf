terraform {
  required_providers {
    metal = {
      source = "metalstack.cloud/terraform/metal"
    }
  }
}

resource "metal_cluster" "app_cluster" {
  name       = var.cluster_name
  kubernetes = "1.26.9"
  workers = [
    {
      name            = "default"
      machine_type    = "n1-medium-x86"
      min_size        = 1
      max_size        = 2
      max_surge       = 1
      max_unavailable = 1
    }
  ]
  # maintenance = {
  #   time_window = {
  #     begin    = "01:00 AM"
  #     duration = 2
  #   }
  # }
}
