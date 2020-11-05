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
    ingress = object({
      host                  = string
      tls_secret_name       = string
      basic_auth_enabled    = bool
      asm_basic_auth_secret = string
      basic_auth_secret     = string
      annotations           = map(string)
    })
    git = object({
      asm_secret_name = string
      secret_name     = string,
      secret_data_key = string
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