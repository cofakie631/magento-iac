resource "aws_vpc" "custom_vpc" {
  cidr_block = var.custom_vpc_ipv4

  instance_tenancy = "default"

    tags = {
    Name = "Custom VPC"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "internet gateway"
  }
}

resource "aws_route" "r" {
  route_table_id = aws_vpc.custom_vpc.main_route_table_id
  gateway_id = aws_internet_gateway.gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "public_network1" { 
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = var.public_network1_cidr

  map_public_ip_on_launch = true

  tags = {
      Name = "public network1"
  }
}

resource "aws_route_table_association" "public_network1_rt_a" {
  subnet_id      = aws_subnet.public_network1.id
  route_table_id = aws_vpc.custom_vpc.default_route_table_id
}


resource "aws_subnet" "public_network2" { 
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = var.public_network2_cidr

  map_public_ip_on_launch = true

  tags = {
      Name = "public network2"
  }
}

resource "aws_route_table_association" "public_network2_rt_a" {
  subnet_id      = aws_subnet.public_network2.id
  route_table_id = aws_vpc.custom_vpc.default_route_table_id
}

# resource "aws_route53_zone" "main-hosted-zone" {
#   name = "letsserveitnow.com"
# }

# resource "aws_route53_zone" "sub-hosted-zone" {
#   name = "magento.letsserveitnow.com"
# }

# resource "aws_route53_record" "magento-dns-record" {
#   zone_id = aws_route53_zone.main-hosted-zone.zone_id
#   name    = "magento.letsserveitnow.com"
#   type    = "A"
#   ttl     = "30"
#   records = aws_route53_zone.sub-hosted-zone.name_servers
# }

# resource "aws_acm_certificate" "magento-cert" {
#   domain_name       = "magento.letsserveitnow.com"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

