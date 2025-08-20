variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "server_1_region" {
  type        = string
  description = "Enter the Amazon EC2 Region where the first resource that you specified in this record resides. For example: \"us-east-1\""
}

variable "server_1_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to first server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "server_2_region" {
  type        = string
  description = "Enter the Amazon EC2 Region where the second resource that you specified in this record resides. For example: \"ap-southeast-2\""
}

variable "server_2_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to second server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}
