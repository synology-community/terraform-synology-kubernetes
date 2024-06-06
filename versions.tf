terraform {
  required_version = ">= 1.6.0"
  required_providers {
    synology = {
      source  = "synology-community/synology"
      version = ">= 0.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}
