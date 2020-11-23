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
}