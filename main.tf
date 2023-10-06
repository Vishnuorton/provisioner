
data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-2023.*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

}
resource "aws_instance" "Ec2_Instance" {
  ami = data.aws_ami.ami.id                                
  instance_type = var.instance_type                         
  key_name = var.key_name                                   
  security_groups = [ aws_security_group.sg.name ]
  tags = {
    Name = "instance1"            
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "sudo yum update -y",
      "sudo yum install -httpd",
      "sudo systemctl httpd start"
    ]
  }
  
  provisioner "file" {
    source = "index.html"
    destination = "index/index.html"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file("Vishnu.pem")
    timeout = "3m"
  }

 

}

resource "aws_security_group" "sg" {
  name = "sg"
  description = "allow http and ssh"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}