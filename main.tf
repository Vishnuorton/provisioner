
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
  count = length(var.availability_zone)                     #count is one of the metadata/argument used in resource block only.if we want to create
  ami = data.aws_ami.ami.id                                 #same resource multiple times then use count.here we create instances based on number of availabilty zones
  instance_type = var.instance_type                         #check variable.tf file.like for loop 
  availability_zone = var.availability_zone[count.index]    #------>array concept 
  key_name = var.key_name                                   #check output.tf to print multiple public ip of instances
  security_groups = [ aws_security_group.sg.name ]
  tags = {
    Name = "${var.instance_name} ${count.index}"            #can't use + so instead use "${}"
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