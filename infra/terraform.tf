

terraform {
  required_version = "~> 1.12.0"
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.26.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "vultr" {
  api_key = var.VULTR_API_KEY
}
