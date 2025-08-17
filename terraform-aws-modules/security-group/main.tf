terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

resource "aws_security_group" "custom" {
  vpc_id = var.vpc_id
  tags = merge(var.tags, {
    Name = "[${var.tags.Project}] ${var.name}"
  })
}

# Ingress rules

resource "aws_vpc_security_group_ingress_rule" "http_ipv4" {
  count             = length(lookup(var.ingress, "http_ipv4", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.ingress.http_ipv4[count.index]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "http_ipv6" {
  count             = length(lookup(var.ingress, "http_ipv6", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv6         = var.ingress.http_ipv6[count.index]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "https_ipv4" {
  count             = length(lookup(var.ingress, "https_ipv4", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.ingress.https_ipv4[count.index]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "https_ipv6" {
  count             = length(lookup(var.ingress, "https_ipv6", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv6         = var.ingress.https_ipv6[count.index]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ipv4" {
  count             = length(lookup(var.ingress, "ssh_ipv4", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.ingress.ssh_ipv4[count.index]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ipv6" {
  count             = length(lookup(var.ingress, "ssh_ipv6", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv6         = var.ingress.ssh_ipv6[count.index]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "custom" {
  count             = length(var.ingress_custom)
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.ingress_custom[count.index].cidr_ipv4
  cidr_ipv6         = var.ingress_custom[count.index].cidr_ipv6
  ip_protocol       = var.ingress_custom[count.index].ip_protocol
  from_port         = var.ingress_custom[count.index].from_port
  to_port           = var.ingress_custom[count.index].to_port
}

# Egress rules

resource "aws_vpc_security_group_egress_rule" "http_ipv4" {
  count             = length(lookup(var.egress, "http_ipv4", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.egress.http_ipv4[count.index]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "http_ipv6" {
  count             = length(lookup(var.egress, "http_ipv6", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv6         = var.egress.http_ipv6[count.index]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "https_ipv4" {
  count             = length(lookup(var.egress, "https_ipv4", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.egress.https_ipv4[count.index]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "https_ipv6" {
  count             = length(lookup(var.egress, "https_ipv6", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv6         = var.egress.https_ipv6[count.index]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "ssh_ipv4" {
  count             = length(lookup(var.egress, "ssh_ipv4", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.egress.ssh_ipv4[count.index]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ssh_ipv6" {
  count             = length(lookup(var.egress, "ssh_ipv6", []))
  security_group_id = aws_security_group.custom.id
  cidr_ipv6         = var.egress.ssh_ipv6[count.index]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  count             = var.egress_all ? 1 : 0
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "custom" {
  count             = length(var.egress_custom)
  security_group_id = aws_security_group.custom.id
  cidr_ipv4         = var.egress_custom[count.index].cidr_ipv4
  cidr_ipv6         = var.egress_custom[count.index].cidr_ipv6
  ip_protocol       = var.egress_custom[count.index].ip_protocol
  from_port         = var.egress_custom[count.index].from_port
  to_port           = var.egress_custom[count.index].to_port
}
