terraform {

  backend "local" {
    path = "../state_files/terraform.tfstate"
  }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}
