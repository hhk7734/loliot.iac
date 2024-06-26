terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.25, < 3.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12, < 3.0"
    }
  }

  required_version = ">= 1.7, < 2.0"

  backend "local" {
    # 변수 허용 안됨
    path = "../../../../local_secret/ap-northeast-2/lol-iot/terraform/core/terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path = "${local.cluster_dir}/k0s/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "${local.cluster_dir}/k0s/kubeconfig"
  }
}

locals {
  cluster_dir = "${path.root}/../../../../local_secret/ap-northeast-2/lol-iot"
  secret_dir  = "${path.root}/../../../../local_secret/ap-northeast-2/lol-iot/terraform/secret"

  control_plane_node_affinity = {
    requiredDuringSchedulingIgnoredDuringExecution = {
      nodeSelectorTerms = [
        {
          matchExpressions = [
            {
              key      = "node-role.kubernetes.io/control-plane"
              operator = "In"
              values = [
                "true",
              ]
            },
          ]
        },
      ]
    }
  }

  master_toleration = {
    effect   = "NoSchedule"
    key      = "node-role.kubernetes.io/master"
    operator = "Exists"
  }
}
