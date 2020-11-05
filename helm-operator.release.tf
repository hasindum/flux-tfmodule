data template_file "helm_operator_values" {
  for_each = var.fluxcd

  template = file("${path.module}/helm-values/helm-operator.yaml")
  vars = {
    git_secret_name = each.value.git["secret_name"]
    known_hosts     = each.value.git["known_hosts"]
    namespace       = each.key
  }
}


resource "helm_release" "helm_operator" {
  for_each = var.fluxcd

  namespace       = each.key
  name            = "helm-${each.key}"
  chart           = "helm-operator"
  version         = local.helm_operator.version
  repository      = local.helm_operator.repo
  cleanup_on_fail = true
  max_history     = 3
  wait            = true
  timeout         = 300

  values = [
    data.template_file.helm_operator_values[each.key].rendered,
  ]

  depends_on = [kubernetes_namespace.ns, kubernetes_secret.flux_ssh_key, null_resource.wait_for]
}
