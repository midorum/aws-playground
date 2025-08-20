variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "server_1_country_code" {
  type        = string
  description = "Enter the two-letter country codes that are specified in ISO standard 3166-1 (see README.md for details)"
  default     = "US"
}

variable "server_1_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to first server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "server_2_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to second server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}
