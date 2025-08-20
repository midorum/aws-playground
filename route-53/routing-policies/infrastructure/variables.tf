variable "common_tags" {
  type = map(string)
  default = {
    Project     = "aws-playground"
    Environment = "dev"
  }
}
