data template_file "fluxcd_values" {
  for_each = var.fluxcd

  template = file("${path.module}/helm-values/fluxcd.yaml")
  vars = {
    git_secret_name     = "flux-git-deploy"
    git_secret_data_key = "identity"
    git_url             = each.value.git["url"]
    git_path            = each.value.git["path"]
    git_branch          = each.value.git["branch"]
    git_user            = each.value.git["user"]
    git_email           = each.value.git["email"]
    git_label           = "flux-sync-${each.key}"
    ecr_region          = each.value.ecr_region
    ecr_account_ids     = join(",", each.value.ecr_account_ids)
    known_hosts         = each.value.git["known_hosts"]
  }
}


resource "helm_release" "fluxcd" {
  for_each = var.fluxcd

  namespace       = each.key
  name            = "flux-${each.key}"
  chart           = "flux"
  version         = local.flux.version
  repository      = local.flux.repo
  cleanup_on_fail = true
  max_history     = 3
  wait            = true
  timeout         = 300

  values = [
    data.template_file.fluxcd_values[each.key].rendered,
  ]

  depends_on = [kubernetes_namespace.ns, kubernetes_secret.flux_ssh_key, null_resource.wait_for]
}
