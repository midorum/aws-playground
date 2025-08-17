output "vpc" {
  value = {
    id         = aws_vpc.main.id
    cidr_block = aws_vpc.main.cidr_block
  }

}

output "subnets" {
  value = {
    private = {
      ids         = aws_subnet.private_subnets[*].id
      cidr_blocks = aws_subnet.private_subnets[*].cidr_block
    },
    public = {
      ids         = aws_subnet.public_subnets[*].id
      cidr_blocks = aws_subnet.public_subnets[*].cidr_block
    }
  }

}
