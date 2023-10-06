variable "key_name" {
  type = string
  description = "key pair name"
}

variable "availability_zone" {
  type = list(string)
  description = "all availability zone"
}

variable "region" {
  type = string
  description = "working region "
}


variable "instance_name" {
  type = string
  description = "name of the ec2 instance"
}

variable "instance_type" {
  type = string
  description = "name of the ec2 instance"
}