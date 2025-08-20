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

resource "aws_route53_health_check" "http_status" {
  count             = length(var.primary_routes)
  type              = "HTTP"
  ip_address        = var.primary_routes[count.index]
  fqdn              = var.domain
  port              = var.health_check_port
  resource_path     = var.health_check_resource_path
  failure_threshold = var.health_check_failure_threshold
  request_interval  = "30"
  // Tags can only contain letters, numbers, spaces, and the following special characters: _ . : / = + - @
  tags = merge(var.tags, {
    Name = "${var.tags.Project} ${var.primary_routes[count.index]} http_status"
  })
}

resource "aws_route53_health_check" "string_matching" {
  count             = length(var.primary_routes)
  type              = "HTTP_STR_MATCH"
  ip_address        = var.primary_routes[count.index]
  fqdn              = var.domain
  port              = var.health_check_port
  resource_path     = var.health_check_resource_path
  failure_threshold = var.health_check_failure_threshold
  request_interval  = "30"
  search_string     = var.health_check_search_string
  // Tags can only contain letters, numbers, spaces, and the following special characters: _ . : / = + - @
  tags = merge(var.tags, {
    Name = "${var.tags.Project} ${var.primary_routes[count.index]} string_matching"
  })
}

resource "aws_route53_health_check" "calculated" {
  type                   = "CALCULATED"
  child_health_threshold = 1
  child_healthchecks = flatten([
    aws_route53_health_check.http_status[*].id,
    aws_route53_health_check.string_matching[*].id
  ])
  // Tags can only contain letters, numbers, spaces, and the following special characters: _ . : / = + - @
  tags = merge(var.tags, {
    Name = "${var.tags.Project} calculated"
  })
}

resource "aws_route53_record" "primary" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain
  type    = "A"
  ttl     = 300
  failover_routing_policy {
    type = "PRIMARY"
  }
  health_check_id = aws_route53_health_check.calculated.id
  set_identifier  = "primary_server"
  records         = var.primary_routes
}

resource "aws_route53_record" "secondary" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.domain
  type    = "A"
  ttl     = 300
  failover_routing_policy {
    type = "SECONDARY"
  }
  set_identifier = "secondary_server"
  records        = var.secondary_routes
}
