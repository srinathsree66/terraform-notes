# Local provider is used to create local files on the machine where Terraform is run. It is useful for testing and debugging purposes.

terraform {
  required_providers {
    local={
        source = "hashicorp/local"
        version = "2.5.1"
    }
  }
}