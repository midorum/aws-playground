variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "route_to" {
  type        = list(string)
  description = "Enter list of IPs to route traffic to in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}
