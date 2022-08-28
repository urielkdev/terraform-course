variable "region" {
  type = string
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "main_vpc_name" {
  type    = string
  default = "Main VPC"
}

variable "ssh_key_path" {
  type = string
}
