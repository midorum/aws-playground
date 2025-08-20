output "project_tag" {
  value = var.common_tags.Project
}

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
