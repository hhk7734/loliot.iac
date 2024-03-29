resource "helm_release" "cilium" {
  chart       = "${local.charts_dir}/cilium-1.14.6.tgz"
  max_history = 5
  name        = "cilium"
  namespace   = "kube-system"
  timeout     = 300
  values = [jsonencode(
    {
      k8sServiceHost = "localhost"
      k8sServicePort = "6443"
      cluster = {
        name = "home-lol-iot"
      }
      l2announcements = {
        enabled = "true"
      }
      ipam = {
        mode = "cluster-pool"
        operator = {
          clusterPoolIPv4MaskSize = 25
          clusterPoolIPv4PodCIDRList = [
            "10.233.64.0/18",
          ]
        }
      },
      kubeProxyReplacement = "true"
      operator = {
        replicas = 1
      }
    }
  )]
  wait = true
}
