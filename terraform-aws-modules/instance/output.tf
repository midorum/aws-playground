output "instance" {
  value = {
    id         = aws_instance.server.id
    ami        = aws_instance.server.ami
    private_ip = aws_instance.server.private_ip
    public_ip  = aws_instance.server.public_ip
  }
}
