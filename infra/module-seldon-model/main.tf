locals {
  # Yaml regexp expression to clean up double quotes from keys / and or remove double quotes from values
  yaml_encode_replace_quotes_regexp = "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/"
  # Generating resources as yaml
  resources_limits   = indent(14, chomp(replace(yamlencode(var.resources_limits), local.yaml_encode_replace_quotes_regexp, "$1$2:")))
  resources_requests = indent(14, chomp(replace(yamlencode(var.resources_requests), local.yaml_encode_replace_quotes_regexp, "$1$2:")))

  graph = indent(6, chomp(replace(yamlencode(var.graph), local.yaml_encode_replace_quotes_regexp, "$1$2:")))
  image = var.image_spec != null ? indent(10, chomp(replace(yamlencode(var.image_spec), local.yaml_encode_replace_quotes_regexp, "$1$2:"))) : ""

  ssl_template = {
    ssl = {
      certSecretName : "seldon-models-ingress-tls"
    }
  }

  ssl_yaml = var.ssl_enabled ? indent(4, chomp(replace(yamlencode(local.ssl_template), local.yaml_encode_replace_quotes_regexp, "$1$2:"))) : chomp("")
}

resource "kubectl_manifest" "seldon_model" {

  yaml_body = <<YAML
apiVersion: machinelearning.seldon.io/v1
kind: SeldonDeployment
metadata:
  name: ${var.name}
  namespace: ${var.namespace}
spec:
  name: ${var.name}
  annotations:
    seldon.io/rest-timeout: "${var.rest_timeout}"
    seldon.io/grpc-timeout: "${var.grpc_timeout}"
  predictors:
  - componentSpecs:
    - hpaSpec:
        maxReplicas: ${var.hpa_max_replicas}
        minReplicas: ${var.hpa_min_replicas}
        metrics:
        - resource:
            name: cpu
            targetAverageUtilization: ${var.hpa_avg_cpu}
          type: Resource
        - resource:
            name: memory
            targetAverageUtilization: ${var.hpa_avg_mem}
          type: Resource
      spec:
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: ${var.node_affinity_label_key}
                  operator: In
                  values:
                  - ${var.node_affinity_label_value}
        containers:
        - name: ${var.container_name}
          ${local.image}
          resources:
            limits:
              ${local.resources_limits}
            requests:
              ${local.resources_requests}
        terminationGracePeriodSeconds: ${var.termination_grace_secs}
    graph:
      ${local.graph}
    name: ${var.container_name}
    replicas: ${var.hpa_min_replicas}
    ${local.ssl_yaml}
YAML
}

