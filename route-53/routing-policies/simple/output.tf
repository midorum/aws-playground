output "zone" {
  value = {
    id                  = data.aws_route53_zone.selected.id
    name                = data.aws_route53_zone.selected.name
    primary_name_server = data.aws_route53_zone.selected.primary_name_server
  }
}

output "record" {
  value = {
    fqdn    = aws_route53_record.simple.fqdn
    records = aws_route53_record.simple.records
    # _       = aws_route53_record.simple
  }
}
