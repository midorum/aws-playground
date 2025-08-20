terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

provider "aws" {
}

data "aws_route53_zone" "selected" {
  name = var.hosted_zone_name
}

locals {
  server_1_coordinates = split(";", var.server_1_coordinates)
  server_2_coordinates = split(";", var.server_2_coordinates)
}

resource "aws_route53_record" "geoproximity_1" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain
  type    = "A"
  ttl     = 300
  geoproximity_routing_policy {
    coordinates {
      latitude  = local.server_1_coordinates[0]
      longitude = local.server_1_coordinates[1]
    }
    bias = local.server_1_coordinates[2]
  }
  set_identifier = "server-1"
  records        = var.server_1_routes
}

resource "aws_route53_record" "geoproximity_2" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain
  type    = "A"
  ttl     = 300
  geoproximity_routing_policy {
    coordinates {
      latitude  = local.server_2_coordinates[0]
      longitude = local.server_2_coordinates[1]
    }
    bias = local.server_2_coordinates[2]
  }
  set_identifier = "server-2"
  records        = var.server_2_routes
}
