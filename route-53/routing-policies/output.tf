# output "availability_zones" {
#   value = data.aws_availability_zones.available.names
# }

# output "main_vpci_id" {
#   value = module.vpc.vpc_id
# }

# output "main_vpci_cidr_block" {
#   value = module.vpc.vpc_cidr_block
# }

output "us_instance" {
  value = {
    public_ip = module.us_web_server.instance.public_ip
  }
}

output "ap_instance" {
  value = {
    public_ip = module.ap_web_server.instance.public_ip
  }
}
