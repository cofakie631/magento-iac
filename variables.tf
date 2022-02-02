variable "name_prefix" {
  default = "Sofia-Tasopoulou"
}

variable "region" {
    default = "us-east-2"
}

variable "custom_vpc_ipv4" {
    default = "172.32.0.0/16"
}

variable "public_network1_cidr" {
  default = "172.32.2.0/24"
}

variable "public_network2_cidr" {
  default = "172.32.3.0/24"
}

variable "image" {
  default = "ami-03a0c45ebc70f98ea"
}

variable "key_name" {
    default = "magento-instance"
}

variable "ssh_key_file" {
  default = "C:/Users/Sofia/Documents/Sof-practical/magento-instance.pem"
}

variable "server0_number" {
  default = "1"
}

variable "server1_number" {
  default = "1"
}

variable "flavor_t2_micro" {
  default = "t2.micro"
}

variable "flavor_t2_medium" {
    default = "t2.medium"
}


