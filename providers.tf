provider "aws" {
  version = "3.6.0"
  region  = var.region
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  token                  = var.cluster_token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_ca_certificate
    token                  = var.cluster_token
    load_config_file       = false
  }
}

provider "template" {
  version = "2.1.2"
}

provider "null" {
  version = "2.1.2"
}
