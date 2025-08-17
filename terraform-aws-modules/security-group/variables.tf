variable "name" {
  type    = string
  default = "custom-sg"
}

variable "vpc_id" {
  type = string
}

variable "ingress" {
  type = map(list(string))
  default = {
    "http_ipv4"  = []
    "http_ipv6"  = []
    "https_ipv4" = []
    "https_ipv6" = []
  }
}

variable "egress" {
  type = map(list(string))
  default = {
    "http_ipv4"  = []
    "http_ipv6"  = []
    "https_ipv4" = []
    "https_ipv6" = []
  }
}

variable "egress_all" {
  type    = bool
  default = true
}

variable "ingress_custom" {
  description = <<EOT
Custom ingress rules in format:
{
  cidr_ipv4   = (string, optional)
  cidr_ipv6   = (string, optional)
  ip_protocol = (string, required)
  from_port   = (number, required)
  to_port     = (number, required)
}
EOT
  type = list(object({
    cidr_ipv4   = optional(string)
    cidr_ipv6   = optional(string)
    ip_protocol = string
    from_port   = number
    to_port     = number
  }))
  default = []
}

variable "egress_custom" {
  description = <<EOT
Custom egress rules in format:
{
  cidr_ipv4   = (string, optional)
  cidr_ipv6   = (string, optional)
  ip_protocol = (string, required)
  from_port   = (number, required)
  to_port     = (number, required)
}
EOT
  type = list(object({
    cidr_ipv4   = optional(string)
    cidr_ipv6   = optional(string)
    ip_protocol = string
    from_port   = number
    to_port     = number
  }))
  default = []
}

variable "tags" {
  type = map(string)
  default = {
    Project = "aws-playground"
  }
}
