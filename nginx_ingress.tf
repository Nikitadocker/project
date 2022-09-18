provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = nginx-ingress

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}