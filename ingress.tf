resource "kubernetes_secret" "flux_basic_auth" {
  for_each = local.protected_ingresses
  metadata {
    name      = each.value["ingress"]["basic_auth_secret"]
    namespace = each.key
    labels    = local.tags
  }

  data = {
    "auth" = data.aws_secretsmanager_secret_version.flux_api_basic_auth[each.key].secret_string
  }

  depends_on = [kubernetes_namespace.ns]
}

resource "kubernetes_ingress" "flux_api_protected" {
  for_each = local.protected_ingresses

  wait_for_load_balancer = false

  metadata {
    name      = "flux-api"
    namespace = each.key
    annotations = merge({
      "nginx.ingress.kubernetes.io/auth-type"   = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = each.value["ingress"]["basic_auth_secret"]
      "nginx.ingress.kubernetes.io/auth-realm"  = "Unauthorized"
    }, each.value["ingress"]["annotations"])
    labels = local.tags
  }

  spec {
    dynamic "tls" {
      for_each = each.value["ingress"]["tls_secret_name"] != "" ? [each.value["ingress"]["tls_secret_name"]] : []
      content {
        secret_name = each.value["ingress"]["tls_secret_name"]
        hosts       = [each.value["ingress"]["host"]]
      }
    }

    rule {
      host = each.value["ingress"]["host"]
      http {
        path {
          backend {
            service_name = "flux-${each.key}"
            service_port = 3030
          }
          path = "/"
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.ns]
}

resource "kubernetes_ingress" "flux_api_unprotected" {
  for_each = local.unprotected_ingresses

  wait_for_load_balancer = false

  metadata {
    name        = "flux-api"
    namespace   = each.key
    labels      = local.tags
    annotations = each.value["ingress"]["annotations"]
  }

  spec {
    dynamic "tls" {
      for_each = each.value["ingress"]["tls_secret_name"] != "" ? [each.value["ingress"]["tls_secret_name"]] : []
      content {
        secret_name = each.value["ingress"]["tls_secret_name"]
        hosts       = [each.value["ingress"]["host"]]
      }
    }

    rule {
      host = each.value["ingress"]["host"]
      http {
        path {
          backend {
            service_name = "flux-${each.key}"
            service_port = 3030
          }
          path = "/"
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.ns]
}