terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}


resource "local_file" "file1" {
  filename = "${path.module}/${var.filename_1}"
  content  = var.filename_1_content
}

resource "local_file" "file2" {
  filename = "${path.module}/${var.filename_2}"
  content  = var.filename_2_content
}
