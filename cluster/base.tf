terraform {
  required_version = ">= 1.10.3"

  backend "s3" {
    bucket       = "mnr-state"
    key          = "manura/cluster.tfstate"
    region       = "auto"
    use_lockfile = true

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true

    endpoints = {
      s3 = "https://0dadaa1ae08a9c7fdbc54393c0a0e5c5.r2.cloudflarestorage.com"
    }
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path    = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}
