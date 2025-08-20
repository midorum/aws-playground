variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "server_1_cidrs" {
  type        = list(string)
  description = "Enter list of CIDRs that will be routed to the first resource in format '[\"10.0.1.0/0\", \"10.0.2.0/24\", \"2001::/0\", \"2002:db8::/48\"]'"
}

variable "server_1_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to first server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "server_2_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to second server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}
