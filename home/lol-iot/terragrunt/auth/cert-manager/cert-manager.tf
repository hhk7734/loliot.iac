resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  repository  = "https://hhk7734.github.io/helm-charts/"
  chart       = "cert-manager"
  version     = "v1.16.2"
  max_history = 3
  name        = "cert-manager"
  namespace   = kubernetes_namespace.cert_manager.metadata[0].name
  timeout     = 300
  values = [jsonencode(
    {
      crds = {
        enabled = true
      }
      enableCertificateOwnerRef = true
      resources = {
        requests = {
          cpu    = "10m"
          memory = "32Mi"
        }
      }
    }
  )]
}
