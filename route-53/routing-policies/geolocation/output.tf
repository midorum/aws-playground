output "zone" {
  value = {
    id                  = data.aws_route53_zone.selected.id
    name                = data.aws_route53_zone.selected.name
    primary_name_server = data.aws_route53_zone.selected.primary_name_server
  }
}

output "server_1_record" {
  value = {
    fqdn                    = aws_route53_record.geolocation_1.fqdn
    records                 = aws_route53_record.geolocation_1.records
    weighted_routing_policy = aws_route53_record.geolocation_1.geolocation_routing_policy
    # _       = aws_route53_record.geolocation_1
  }
}

output "server_2_record" {
  value = {
    fqdn                    = aws_route53_record.geolocation_2.fqdn
    records                 = aws_route53_record.geolocation_2.records
    weighted_routing_policy = aws_route53_record.geolocation_2.geolocation_routing_policy
    # _       = aws_route53_record.geolocation_2
  }
}
