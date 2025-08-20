variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "health_check_port" {
  type        = number
  default     = 80
  description = "The port of the endpoint to be checked"
}

variable "health_check_resource_path" {
  type        = string
  default     = "/"
  description = "The path that you want Amazon Route 53 to request when performing health checks."
}

variable "health_check_failure_threshold" {
  type        = string
  default     = "3"
  description = "The number of consecutive health checks that an endpoint must pass or fail."
}

variable "health_check_search_string" {
  type        = string
  default     = "Hello"
  description = "String searched in the first 5120 bytes of the response body for check to be considered healthy."
}

variable "primary_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to primary instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "secondary_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to secondary instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "aws-playground"
  }
}
