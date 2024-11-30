# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
provider "kubernetes" {
  config_paths   = ["~/.kube/config","~/.kube/lol-iot.yaml"]
  config_context = "home/lol-iot/admin"
}

provider "helm" {
  kubernetes {
    config_paths   = ["~/.kube/config","~/.kube/lol-iot.yaml"]
    config_context = "home/lol-iot/admin"
  }
}