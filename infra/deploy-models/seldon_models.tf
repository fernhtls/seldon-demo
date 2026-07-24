### Seldon Models deployment

resource "kubernetes_namespace_v1" "seldon_models" {
  metadata {
    name = "seldon-models"
  }
}

## Demo model
module "seldon_demo_model" {
  namespace = kubernetes_namespace_v1.seldon_models.metadata[0].name
  name      = "seldon-demo-model"
  source    = "../module-seldon-model"
  depends_on = [
    kubernetes_namespace_v1.seldon_models
  ]
  graph = {
    children = []
    endpoint = {
      type = "GRPC"
    }
    name = "classifier"
    type = "MODEL"
  }
  image_spec = {
    image           = "docker.io/library/seldon-mock-model:v1.0.0" # local imnage loaded to the cluster 
    imagePullPolicy = "Never"
  }
}
