terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.20.0"
    }
  }
}

provider "vault" {
  address = "http://<YourVAULT_IP>:8200"
}
