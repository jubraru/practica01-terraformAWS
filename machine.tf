resource "aws_instance" "web" {
  # ami a instalar
  ami = "ami-0b589b2819c2045c3"
  # tipo de instancia
  instance_type = "t2.micro"
  # clave ssh asociada por defecto
  key_name = aws_key_pair.deployer.key_name
  # zona de disponibilidad
  availability_zone = var.availability_zone
  vpc_security_group_ids = [aws_security_group.allow_ssh.id,aws_security_group.allow_http.id,aws_security_group.allow_https.id]
  subnet_id = element(module.vpc.public_subnets,1)
  tags = {
    Name = "Ejercicio1"
  }
}