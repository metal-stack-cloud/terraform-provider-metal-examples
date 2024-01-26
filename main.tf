terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    local = {
      source = "hashicorp/local"
    }
    metal = {
      source = "metal-stack-cloud/metal"
    }
  }
}

# PROVIDERS

provider "metal" {
  # All arguments are optional and can be omitted
  # The defaults are derived from the environment variables METAL_STACK_CLOUD_* or ~/.metal-stack-cloud/config.yaml
}
provider "kubernetes" {
  # requires: resource.local_sensitive_file.kubeconfig
  # $ terraform apply -target local_sensitive_file.kubeconfig
  config_path = local.kubeconfig_path
}

# MODULES

module "metal-infra" {
  source       = "./metal-infra"
  cluster_name = local.app_cluster_name
}

module "metal-app" {
  depends_on      = [module.metal-infra]
  source          = "./metal-app"
  kubeconfig_path = local.kubeconfig_path
}

# LOCALS

locals {
  app_cluster_name = "example-app"
  kubeconfig_path  = "${path.root}/app.kubeconfig"
}

# GENERATE KUBECONFIG

# query app cluster to get the ID
data "metal_cluster" "app_cluster" {
  # it make sure the cluster exists
  depends_on = [module.metal-infra]

  name = local.app_cluster_name
}
# generate kubeconfig for the app cluster
data "metal_kubeconfig" "app_kubeconfig" {
  id         = data.metal_cluster.app_cluster.id
  expiration = "10m"
}
# write the kubeconfig to file
resource "local_sensitive_file" "kubeconfig" {
  content  = data.metal_kubeconfig.app_kubeconfig.raw
  filename = local.kubeconfig_path
}

