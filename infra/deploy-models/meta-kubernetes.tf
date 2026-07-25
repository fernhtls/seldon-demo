locals {
  # Change the k8s config
  config_path    = "~/.kube/config"
  config_context = "minikube-fsouza1"
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
}

provider "kubectl" {
  apply_retry_count = 3 # number of attempts any create/update action will take.
  config_path       = local.config_path
  config_context    = local.config_context
}
