output "zone" {
  value = {
    id                  = data.aws_route53_zone.selected.id
    name                = data.aws_route53_zone.selected.name
    primary_name_server = data.aws_route53_zone.selected.primary_name_server
  }
}

output "server_1_record" {
  value = {
    fqdn                    = aws_route53_record.geoproximity_1.fqdn
    records                 = aws_route53_record.geoproximity_1.records
    weighted_routing_policy = aws_route53_record.geoproximity_1.geoproximity_routing_policy
    # _       = aws_route53_record.geoproximity_1
  }
}

output "server_2_record" {
  value = {
    fqdn                    = aws_route53_record.geoproximity_2.fqdn
    records                 = aws_route53_record.geoproximity_2.records
    weighted_routing_policy = aws_route53_record.geoproximity_2.geoproximity_routing_policy
    # _       = aws_route53_record.geoproximity_2
  }
}
