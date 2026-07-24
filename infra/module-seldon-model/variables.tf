variable "namespace" {
  type = string
  validation {
    condition     = length(var.namespace) > 0
    error_message = "Variable 'namespace' can't be empty"
  }
}

variable "name" {
  type = string
  validation {
    condition     = length(var.name) > 0
    error_message = "Variable 'name' can't be empty"
  }
}

variable "hpa_max_replicas" {
  type    = number
  default = 3
}

variable "hpa_min_replicas" {
  type    = number
  default = 1
}

variable "hpa_avg_cpu" {
  type    = number
  default = 70
}

variable "hpa_avg_mem" {
  type    = string
  default = 70
}

variable "termination_grace_secs" {
  type    = number
  default = 5
}

variable "container_name" {
  type    = string
  default = "classifier"
}

variable "model_name" {
  type    = string
  default = "default"
}

variable "graph" {
  description = "(mandatory) check README for reference"
}

variable "resources_limits" {
  type = object({
    cpu    = string
    memory = string
  })
  description = "Pod limit resources (needed for the hpa settings)"
  default = {
    cpu    = "0.2"
    memory = "512Mi"
  }
}

variable "resources_requests" {
  type = object({
    cpu    = string
    memory = string
  })
  description = "Pod requests resources (needed for the hpa settings)"
  default = {
    cpu    = "0.1"
    memory = "256Mi"
  }
}

variable "node_affinity_label_key" {
  type    = string
  default = "kubernetes.io/hostname"
}

variable "node_affinity_label_value" {
  type    = string
  default = "minikube"
}

variable "image_spec" {
  type = object({
    image           = string
    imagePullPolicy = string
  })
  description = "(optional) image spec to use to seldon deployment"
  validation {
    condition     = length(var.image_spec.image) > 0 && length(var.image_spec.imagePullPolicy) > 0
    error_message = "Variable 'image_spec.image' and 'image_spec.imagePullPolicy' must not be empty."
  }
}

variable "rest_timeout" {
  type        = number
  default     = 300000
  description = "REST seldon timeout in ms - default 3s (out default 5mins )"
}

variable "grpc_timeout" {
  type        = number
  default     = 300000
  description = "REST seldon timeout in ms - default 3s (out default 5mins )"
}

variable "ssl_enabled" {
  type        = bool
  default     = false
  description = "Set's the ssl cert secret if true, enabling ssl / https connections"
}

// variable "ssl_dns" {
//   type        = string
//   default     = "{}"
//   description = "Set's the dns host used for the certificate for the ssl connections"
// }
