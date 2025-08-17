variable "name" {
  type    = string
  default = "web-server"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "user_data_file" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
  default = {
    Project = "aws-playground"
  }
}
