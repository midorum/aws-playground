variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "server_1_weight" {
  type        = number
  default     = 10
  description = "A value that determines the proportion of DNS queries that Route 53 responds to using the first resource record."
}

variable "server_1_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to first server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "server_2_weight" {
  type        = number
  default     = 90
  description = "A value that determines the proportion of DNS queries that Route 53 responds to using the second resource record."
}

variable "server_2_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to second server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}
