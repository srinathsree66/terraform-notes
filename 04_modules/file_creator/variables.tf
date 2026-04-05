variable "filename_1" {
  type    = string
  default = "file1.txt"
}
variable "filename_2" {
  type    = string
  default = "file2.txt"
}


variable "filename_1_content" {
  type        = string
  default     = "hello from file 1"
  description = "this is the content of file1"
}

variable "filename_2_content" {
  type        = string
  default     = "hello from file 2"
  description = "this is the content of file2"
}
