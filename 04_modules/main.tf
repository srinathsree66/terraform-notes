terraform {

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}



# module

module "create_files" {
  source             = "./file_creator"
  filename_1         = "my_first_file.txt"
  filename_1_content = "from file1"

  filename_2         = "my_second_file.txt"
  filename_2_content = "from file2"
}


output "file_paths" {
  value = [
    module.create_files.file1_path,
    module.create_files.file2_path
  ]
}
