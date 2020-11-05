locals {

  flux = {
    repo    = "https://charts.fluxcd.io"
    version = "1.5.0"
  }

  helm_operator = {
    repo    = "https://charts.fluxcd.io"
    version = "1.2.0"
  }

  tags = {
    "managed-by" : "Terraform"
  }

  _ingk     = [for k, v in var.fluxcd : k if v["ingress"] != null]
  _ingv     = [for k, v in var.fluxcd : v if v["ingress"] != null]
  ingresses = zipmap(local._ingk, local._ingv)

  _ingprtk            = [for k, v in local.ingresses : k if v["ingress"]["basic_auth_enabled"] == true]
  _ingprtv            = [for k, v in local.ingresses : v if v["ingress"]["basic_auth_enabled"] == true]
  protected_ingresses = zipmap(local._ingprtk, local._ingprtv)

  _ingunprtk            = [for k, v in local.ingresses : k if v["ingress"]["basic_auth_enabled"] == false]
  _ingunprtv            = [for k, v in local.ingresses : v if v["ingress"]["basic_auth_enabled"] == false]
  unprotected_ingresses = zipmap(local._ingunprtk, local._ingunprtv)
}