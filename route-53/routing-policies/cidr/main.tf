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

resource "aws_route53_cidr_collection" "example" {
  name = "collection-1"
}

resource "aws_route53_cidr_location" "example" {
  cidr_collection_id = aws_route53_cidr_collection.example.id
  name               = "location-1"
  cidr_blocks        = var.server_1_cidrs
}

resource "aws_route53_record" "cidr_1" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain
  type    = "A"
  ttl     = 300
  cidr_routing_policy {
    collection_id = aws_route53_cidr_collection.example.id
    location_name = aws_route53_cidr_location.example.name
  }
  set_identifier = "server-1"
  records        = var.server_1_routes
}

resource "aws_route53_record" "cidr_2" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain
  type    = "A"
  ttl     = 300
  cidr_routing_policy {
    collection_id = aws_route53_cidr_collection.example.id
    location_name = "*" // a default CIDR record 
  }
  set_identifier = "server-2"
  records        = var.server_2_routes
}
