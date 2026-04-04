# simple file resource (local provider) to create a file on the local machine where Terraform is run. This is useful for testing and debugging purposes.

resource "local_file" "tf_example1" {
  #   filename = "01_basics/example1.txt"
  filename = "${path.module}/example${count.index}.txt"
  content  = "This is updated content for example${count.index}.txt created by Terraform using local provider. ${count.index}"
  count    = 3

}

resource "local_sensitive_file" "tf_example2" {
  filename = "${path.module}/example2.txt"
  content  = "This is updated content for example2.txt created by Terraform using local provider."
}
