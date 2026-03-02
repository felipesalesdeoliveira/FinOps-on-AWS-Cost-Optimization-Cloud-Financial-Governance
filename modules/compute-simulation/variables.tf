variable "name" {
  type = string
}

variable "enabled" {
  type    = bool
  default = false
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_ssm_parameter" {
  type    = string
  default = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "subnet_id" {
  type = string
}

variable "required_tags" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
