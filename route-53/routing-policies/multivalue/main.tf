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

resource "aws_route53_record" "multivalue_1" {
  zone_id                          = data.aws_route53_zone.selected.id
  name                             = var.domain
  type                             = "A"
  ttl                              = 300
  multivalue_answer_routing_policy = true
  set_identifier                   = "server-1"
  records                          = var.server_1_routes
}

resource "aws_route53_record" "multivalue_2" {
  zone_id                          = data.aws_route53_zone.selected.id
  name                             = var.domain
  type                             = "A"
  ttl                              = 300
  multivalue_answer_routing_policy = true
  set_identifier                   = "server-2"
  records                          = var.server_2_routes
}
