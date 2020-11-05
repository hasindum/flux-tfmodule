/**
 Fetch the secrets from ASM and get the values to create Kubernetes secrets as required for fluxcd
**/

data "aws_secretsmanager_secret" "git_ssh_key" {
  for_each = var.fluxcd
  name     = each.value.git["asm_secret_name"]
}

data "aws_secretsmanager_secret_version" "git_ssh_key" {
  for_each  = data.aws_secretsmanager_secret.git_ssh_key
  secret_id = each.value.id
}

data aws_secretsmanager_secret "flux_api_basic_auth" {
  for_each = local.protected_ingresses
  name     = each.value["ingress"]["asm_basic_auth_secret"]
}

data "aws_secretsmanager_secret_version" "flux_api_basic_auth" {
  for_each  = data.aws_secretsmanager_secret.flux_api_basic_auth
  secret_id = each.value.id
}