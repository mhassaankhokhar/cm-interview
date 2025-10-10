terraform {
  required_providers {
        kubernetes = {
        source = "hashicorp/kubernetes"
        }
        helm = {
        source  = "hashicorp/helm"
        }
    }
}


provider "kubernetes" {
  config_path = var.config_path
}

provider "helm" {
  kubernetes = {
        host = var.host
       config_path = var.config_path
  }
}

# # ------------------------------------------------------------
# # Ingress Controller
# # ------------------------------------------------------------
resource "helm_release" "nginx_ingress" {

  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          type = "NodePort"
        }
      }
    })
  ]
}

# ------------------------------------------------------------
# Prometheus + Grafana
# ------------------------------------------------------------
resource "helm_release" "kube_prometheus_stack" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    yamlencode({
      grafana = {
        adminUser     = var.grafana_admin_user
        adminPassword = var.grafana_admin_password
        service = {
          type     = "NodePort"
          nodePort = var.grafana_node_port
        }
      }
      prometheus = {
        service = {
          type     = "NodePort"
          nodePort = var.prometheus_node_port
        }
      }
    })
  ]

}

# ------------------------------------------------------------
# Add Loki
# ------------------------------------------------------------
resource "helm_release" "loki" {
  name             = "loki-stack"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = "monitoring"
  create_namespace = true
}
output "grafana_url" {
  value = "http://localhost:${var.grafana_node_port}"
}

output "prometheus_url" {
  value = "http://localhost:${var.prometheus_node_port}"
}