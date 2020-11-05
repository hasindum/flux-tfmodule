/**
 * # Fluxcd Module
 *
 * Creates Fluxcd ready namespaces in Kubernetes
 *
 * # Prerequisites
 *
 * ## tfsec
 *
 * [tfsec](https://github.com/liamg/tfsec) uses static analysis of your terraform templates to spot potential security issues.
 *
 * ## git config
 *
 * hooks directory needs to be set via git configuration variable:
 *
 * ```bash
 * git config core.hooksPath .hooks/
 * ```
 *
 * Usage:
 *
 * ```hcl
 *
 * module "fluxcd" {
 *  source                  = "../"
 *
 *  region                  = "us-east-1"
 *  cluster_endpoint        = "<endpoint for the cluster>"
 *  cluster_token           = "<token for the cluster>"
 *  cluster_ca_certificate  = "<ca certificate for the cluster>"
 *  fluxcd ={
 *     "sample1" = {
 *          memcached_host  = "flux-memcached.flux-system.svc.cluster.local" #Memcached host for the flux
 *          ecr_region      = "us-east-1" #ECR region to look for image changes for auto updates
 *          ecr_account_ids = ["123456789"] #ECR account ID
 *          ingress         = null #Set `null` to not deploy a ingress resource to expose flux api
 *          annotations     = {}
 *          labels          = {}
 *          git = {
 *              asm_secret_name = "flux/flux_deploy" #ASM path to the SSH key
 *              secret_name     = "flux-git-deploy"
 *              secret_data_key = "" #Defaults to `identity`
 *              url             = "git@githu.com:flux.git"
 *              path            = "app" #Path in the git repo
 *              branch          = "master"
 *              user            = "demo"
 *              email           = "demo@demo.com"
 *              known_hosts     = "<output of ssh-keyscan <your_git_host_domain> >" #If you're using private hosted git repos, you should add the output of the command here.
 *          }
 *    }
 *  }
 * }
 *
 * ```
 */
resource "null_resource" "wait_for" {
  count    = length(var.wait_for) > 0 ? 1:0
  triggers = {
    modules = join(",", var.wait_for)
  }
}

resource "kubernetes_namespace" "ns" {
  for_each = var.fluxcd
  metadata {
    name        = each.key
    labels      = merge(local.tags, each.value.labels)
    annotations = each.value.annotations
  }
}

resource "kubernetes_secret" "flux_ssh_key" {
  for_each = var.fluxcd
  metadata {
    name      = each.value.git["secret_name"]
    namespace = each.key
    labels    = local.tags
  }

  data = {
    identity = data.aws_secretsmanager_secret_version.git_ssh_key[each.key].secret_string
  }

  depends_on = [kubernetes_namespace.ns]
}