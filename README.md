# Fluxcd Module

Creates Fluxcd ready namespaces in Kubernetes

# Prerequisites

## tfsec

[tfsec](https://github.com/liamg/tfsec) uses static analysis of your terraform templates to spot potential security issues.

## git config

hooks directory needs to be set via git configuration variable:

```bash
git config core.hooksPath .hooks/
```

Usage:

```hcl

module "fluxcd" {
 source                  = "../"

 region                  = "us-east-1"
 cluster_endpoint        = "<endpoint for the cluster>"
 cluster_token           = "<token for the cluster>"
 cluster_ca_certificate  = "<ca certificate for the cluster>"
 fluxcd ={
    "sample1" = {
         memcached_host  = "flux-memcached.flux-system.svc.cluster.local" #Memcached host for the flux
         ecr_region      = "us-east-1" #ECR region to look for image changes for auto updates
         ecr_account_ids = ["123456789"] #ECR account ID
         ingress         = null #Set `null` to not deploy a ingress resource to expose flux api
         annotations     = {}
         labels          = {}
         git = {
             asm_secret_name = "flux/flux_deploy" #ASM path to the SSH key
             secret_name     = "flux-git-deploy"
             secret_data_key = "" #Defaults to `identity`
             url             = "git@github.com:flux.git"
             path            = "app" #Path in the git repo
             branch          = "master"
             user            = "demo"
             email           = "demo@demo.com"
             known_hosts     = "<output of ssh-keyscan <your_git_host_domain> >" #If you're using private hosted git repos, you should add the output of the command here.
         }
   }
 }
}

```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | 3.6.0 |
| helm | 1.3.0 |
| kubernetes | 1.13.2 |
| null | 2.1.2 |
| template | 2.1.2 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.6.0 |
| helm | 1.3.0 |
| kubernetes | 1.13.2 |
| null | 2.1.2 |
| template | 2.1.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_ca\_certificate | Kubernetes cluster CA certificate | `string` | n/a | yes |
| cluster\_endpoint | Kubernetes cluster endpoint | `string` | n/a | yes |
| cluster\_token | Kubernetes cluster token | `string` | n/a | yes |
| fluxcd | Map of namespaces containing configuration to deploy namespaces with fluxcd | <pre>map(object({<br>    labels          = map(string)<br>    annotations     = map(string)<br>    memcached_host  = string<br>    ecr_region      = string<br>    ecr_account_ids = list(string)<br>    ingress = object({<br>      host                  = string<br>      tls_secret_name       = string<br>      basic_auth_enabled    = bool<br>      asm_basic_auth_secret = string<br>      basic_auth_secret     = string<br>      annotations           = map(string)<br>    })<br>    git = object({<br>      asm_secret_name = string<br>      secret_name     = string,<br>      secret_data_key = string<br>      url             = string<br>      path            = string<br>      branch          = string<br>      user            = string<br>      email           = string<br>      known_hosts     = string<br>    })<br>  }))</pre> | `{}` | no |
| region | AWS region | `string` | n/a | yes |
| wait\_for | null\_resource to manage module dependencies. ex: Fargate profiles | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespaces | List of namespaces created |
| waited\_for | Dependencies that had to be waited for |