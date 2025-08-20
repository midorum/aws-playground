variable "hosted_zone_name" {
  type        = string
  description = "Enter a hosted zone name in format \"example.com.\""
}

variable "domain" {
  type        = string
  description = "Enter a domain name for zone records in format \"test.example.com\""
}

variable "server_1_coordinates" {
  type        = string
  description = "Enter coordinates that correspond to first resource in format 'latitude;longitude;bias'. For example: '49.22;-74.01;0'"
}

variable "server_1_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to first server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}

variable "server_2_coordinates" {
  type        = string
  description = "Enter coordinates that correspond to second resource in format 'latitude;longitude;bias'. For example: '0;0;99'"
}

variable "server_2_routes" {
  type        = list(string)
  description = "Enter list of IPs that correspond to second server instances in format '[\"10.0.1.1\", \"10.0.2.1\"]'"
}
