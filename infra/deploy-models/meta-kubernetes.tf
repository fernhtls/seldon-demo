provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube-fsouza1"
}

provider "kubectl" {
  apply_retry_count = 3 # number of attempts any create/update action will take.
  config_path       = "~/.kube/config"
  config_context    = "minikube-fsouza1"
}
