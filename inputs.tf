variable "wait_for" {
  type        = list(string)
  description = "null_resource to manage module dependencies. ex: Fargate profiles"
  default     = []
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "fluxcd" {
  description = "Map of namespaces containing configuration to deploy namespaces with fluxcd"
  type = map(object({
    labels          = map(string)
    annotations     = map(string)
    memcached_host  = string
    ecr_region      = string
    ecr_account_ids = list(string)
    git = object({
      secret          = string,
      url             = string
      path            = string
      branch          = string
      user            = string
      email           = string
      known_hosts     = string
    })
  }))

  default = {}
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint"
  type        = string
}

variable "cluster_token" {
  description = "Kubernetes cluster token"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  type        = string
}