provider "aws" {
  version = "3.6.0"
  region  = var.region
}

provider "kubernetes" {
  version                = "1.13.3"
  host                   = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  token                  = var.cluster_token
  load_config_file       = false
}

provider "helm" {
  version = "1.2.3"
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
