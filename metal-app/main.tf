terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "demo"
    labels = {
      app = "demo"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "demo"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "demo"
        }
      }
    }
  }

}

resource "kubernetes_service" "nginx-ingress" {
  metadata {
    name = "nginx-ingress"
  }
  spec {
    type = "LoadBalancer"

    selector = {
      app = resource.kubernetes_deployment.nginx.metadata.0.labels.app
    }
    port {
      port        = 8080
      target_port = 80
    }
  }
}
