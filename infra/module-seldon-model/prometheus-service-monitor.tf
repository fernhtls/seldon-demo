# Creating custom service only for metrics exposure for prometheus
# resource "kubernetes_service" "prometheus_metrics_service" {
#   metadata {
#     name      = "${var.name}-scrape"
#     namespace = var.namespace
# 
#     labels = {
#       "prometheus" = "true"
#     }
#   }
#   spec {
#     selector = {
#       "seldon-deployment-id" = var.name,
#       "seldon.io/model"      = "true"
#     }
#     port {
#       name        = "prometheus-scrape"
#       port        = 8000
#       target_port = 8000
#     }
# 
#     type = "ClusterIP"
#   }
