output "zone" {
  value = {
    id                  = data.aws_route53_zone.selected.id
    name                = data.aws_route53_zone.selected.name
    primary_name_server = data.aws_route53_zone.selected.primary_name_server
  }
}

output "server_1_record" {
  value = {
    fqdn                    = aws_route53_record.primary.fqdn
    records                 = aws_route53_record.primary.records
    weighted_routing_policy = aws_route53_record.primary.failover_routing_policy
    # _       = aws_route53_record.primary
  }
}

output "server_2_record" {
  value = {
    fqdn                    = aws_route53_record.secondary.fqdn
    records                 = aws_route53_record.secondary.records
    weighted_routing_policy = aws_route53_record.secondary.failover_routing_policy
    # _       = aws_route53_record.secondary
  }
}
