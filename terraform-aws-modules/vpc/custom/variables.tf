variable "name" {
  type    = string
  default = "custom-vpc"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}




variable "tags" {
  type = map(string)
  default = {
    Project = "aws-playground"
  }
}
