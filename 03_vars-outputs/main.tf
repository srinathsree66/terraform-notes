terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

# locals {
#   base_path = "${path.module}/files"
# }

# resource "local_file" "example1" {
#   filename = "${local.base_path}/${var.filename_1}.txt"
#   content  = "Hello World"
#   count    = var.count_num
# }

# resource "local_file" "example2" {
#   filename = "${local.base_path}/${var.filename_2}.js"
#   content  = "alert('hello')"
# }


locals {
  environment = "dev"
  upper_case  = upper(local.environment)
  base_path   = "${path.module}/configs/${local.upper_case}"
}

resource "local_file" "server_configs" {

  filename = "${local.base_path}/server_config.sh"
  content  = <<EOT

    port=3000
    host=localhost
    env=${local.environment}

    EOT

}


output "server_config_path" {
  value = local_file.server_configs.filename
}
