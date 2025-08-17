terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9.0"
    }
  }
}

# --- US WebSever

provider "aws" {
  region = "us-east-1"
}

module "us_vpc" {
  source = "../../terraform-aws-modules/vpc/custom"
  name   = "main"
}

module "us_sg_web_access" {
  source = "../../terraform-aws-modules/security-group"
  name   = "web-access"
  vpc_id = module.us_vpc.vpc.id
  ingress = {
    http_ipv4 = ["0.0.0.0/0"]
  }
}

module "us_web_server" {
  source          = "../../terraform-aws-modules/instance"
  name            = "web-server"
  subnet_id       = module.us_vpc.subnets.public.ids[0]
  security_groups = [module.us_sg_web_access.security_group_id]
}

# --- Australia WebSever

provider "aws" {
  alias  = "aps2"
  region = "ap-southeast-2"
}

module "ap_vpc" {
  source = "../../terraform-aws-modules/vpc/custom"
  providers = {
    aws = aws.aps2
  }
  name = "main"
}

module "ap_sg_web_access" {
  source = "../../terraform-aws-modules/security-group"
  providers = {
    aws = aws.aps2
  }
  name   = "web-access"
  vpc_id = module.ap_vpc.vpc.id
  ingress = {
    http_ipv4 = ["0.0.0.0/0"]
  }
}

module "ap_web_server" {
  source = "../../terraform-aws-modules/instance"
  providers = {
    aws = aws.aps2
  }
  name            = "web-server"
  subnet_id       = module.ap_vpc.subnets.public.ids[0]
  security_groups = [module.ap_sg_web_access.security_group_id]
}
