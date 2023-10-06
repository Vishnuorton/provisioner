
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

#mandatory to use /bin/bash since terraform may have different shell so we need to inform terraform to use bash shell
#mandatory to use sudo if we going to perform install or update package 
#sudo chmod -R 777 ---> because any file or folder we create it only have rwx-rx-r so we need to give full access to folder
#so that terraform can perform provisioner "file" to copy index to ec2.
#sudo chmod -R 777 ---> it give all file and sub folder in the dir to give full access 

  provisioner "remote-exec" {                 
    inline = [
      "#!/bin/bash",
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo chmod -R 777 /var/www/html"
    ]
  }
    
  provisioner "file" {
    source = "index.html"
    destination = "/var/www/html/index.html"
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
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}