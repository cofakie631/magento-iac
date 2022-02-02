# Building the ec2 instances


# resource "aws_key_pair" "keypair" {
#   key_name = "${var.name_prefix}-key"
#   public_key = "${file("${var.ssh_key_file}.pub")}"
# }

resource "aws_instance" "magento" {
    count = var.server0_number
    ami = var.image
    instance_type = var.flavor_t2_medium
    key_name = var.key_name
    subnet_id = aws_subnet.public_network1.id
    vpc_security_group_ids = [aws_security_group.magento-sg.id]
}


resource "aws_instance" "varnish" {
    count = var.server1_number
    ami = var.image #same ami since we are using Ubuntu 18.04 in both
    instance_type = var.flavor_t2_micro
    key_name = var.key_name #same key to access
    subnet_id = aws_subnet.public_network1.id
    vpc_security_group_ids = [aws_security_group.varnish-sg.id]
}

resource "aws_eip" "magento_instance_IP" {
    instance = aws_instance.magento[0].id
    vpc = true
}

resource "aws_eip" "varnish_instance_IP" {
    instance = aws_instance.varnish[0].id
    vpc = true
}