resource "kubernetes_namespace" "auth" {
  metadata {
    name = "auth"
  }
}

resource "helm_release" "cert-manager" {
  repository  = "https://hhk7734.github.io/helm-charts/"
  chart       = "cert-manager"
  version     = "v1.13.3"
  max_history = 3
  name        = "cert-manager"
  namespace   = kubernetes_namespace.auth.metadata[0].name
  timeout     = 300
  values = [jsonencode(
    {
      global = {
        commonLabels = {}
      }
      installCRDs               = true
      enableCertificateOwnerRef = true
      resources = {
        requests = {
          cpu    = "10m"
          memory = "32Mi"
        }
      }
      affinity    = { nodeAffinity = local.control_plane_node_affinity }
      tolerations = [local.master_toleration]
      cainjector = {
        affinity    = { nodeAffinity = local.control_plane_node_affinity }
        tolerations = [local.master_toleration]
      }
      startupapicheck = {
        affinity    = { nodeAffinity = local.control_plane_node_affinity }
        tolerations = [local.master_toleration]
      }
      webhook = {
        affinity    = { nodeAffinity = local.control_plane_node_affinity }
        tolerations = [local.master_toleration]
      }
    }
  )]
  wait = true
}

resource "helm_release" "casdoor" {
  repository  = "https://hhk7734.github.io/helm-charts/"
  chart       = "casdoor-helm-charts"
  version     = "v1.514.0"
  max_history = 3
  name        = "casdoor"
  namespace   = kubernetes_namespace.auth.metadata[0].name
  timeout     = 300
  values = [jsonencode(
    {
      fullnameOverride = "casdoor"
      config           = <<-EOT
                            appname = casdoor
                            httpport = {{ .Values.service.port }}
                            runmode = dev
                            SessionOn = true
                            copyrequestbody = true
                            driverName = postgres
                            dataSourceName = "user=casdoor password=casdoor host=postgresql.storage.svc.cluster.local port=5432 sslmode=disable dbname=casdoor"
                            dbName =
                            redisEndpoint =
                            defaultStorageProvider =
                            isCloudIntranet = false
                            authState = "casdoor"
                            socks5Proxy = ""
                            verificationCodeTimeout = 10
                            initScore = 0
                            logPostOnly = true
                            origin =
                            enableGzip = true
                        EOT
      affinity         = { nodeAffinity = local.control_plane_node_affinity }
      tolerations      = [local.master_toleration]
    }
  )]
  wait = true
}
