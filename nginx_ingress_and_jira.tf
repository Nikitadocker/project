provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "nginx-ingress"
  create_namespace = "true"
  version = var.chart_version
}

resource "helm_release" "jira_server" {
  name       = "jira"
  repository = "https://helm.mox.sh"
  chart      = "jira-software"
  namespace  = "jira"
  create_namespace = "true"
  version = var.chart_version_jira

  values = [
    "${file("values.yaml")}"
  ]

}