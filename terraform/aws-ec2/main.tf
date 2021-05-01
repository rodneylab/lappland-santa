variable "bucket" {}
variable "image" {}
variable "image_file" {}
variable "image_name" {}
variable "image_family" { default = "openbsd-amd64-68" }
variable "lappland_id" { default = "lappland" }
variable "mail_clients" {}
variable "mail_server" {}
variable "project_id" {}
variable "region" {}
variable "server_name" {}
variable "ssh_key" {}
variable "ssh_port" {}
variable "wg_port" {}
variable "firewall_select_source" {}

variable "profile" { default = "default" }

terraform {
  required_providers {
    google = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "lappland" {
  cidr_block          = "172.16.0.0/16"
  instance_tenancy    = "default"
  enable_dns_support  = true
  enable_dns_hostname = true

  tags = {
    Name = "lappland"
  }
}

resource "aws_internet_gateway" "lappland_gateway" {
  vpc_id = aws_vpc.lappland.id

  tags = {
    Name = "lappland"
  }
}

resource "aws_subnet" "lappland" {
  cidr_block              = "172.16.254.0/23"
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.lappland.id

  tags = {
    Name = "lappland"
  }
}

# resource "aws_vpn_gateway_attachment" "vpn_attachment" {
#   vpc_id         = aws_vpc.lappland.id
#   vpn_gateway_id = aws_internet_gateway.lappland_gateway.id
# }

resource "aws_route_table" "lappland_route_table" {
  vpc_id = aws_vpc.lappland.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lappland_gateway.id
  }

  # depends_on = [aws_vpn_gateway_attachment.vpn_attachment]
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.lappland.id
  route_table_id = aws_route_table.lappland_route_table.id
}

resource "aws_security_group" "lappland_santa_wireguard" {
  name        = "lappland_santa_wireguard"
  description = "Allow peer inbound WireGuard traffic and default outbound"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "SMTP from MTA"
    from_port   = var.wg_port
    to_port     = var.wg_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.firewall_select_source]
  }

  tags = {
    Name = "allow_peer_wireguard"
  }
}

resource "aws_security_group" "lappland_santa_ssh" {
  name        = "lappland_santa_ssh"
  description = "Allow peer inbound SSH traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "SMTP from MTA"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.firewall_select_source]
  }

  tags = {
    Name = "allow_peer_wireguard"
  }
}

resource "aws_security_group" "lappland_santa_mta_smtp" {
  name        = "lappland_santa_mta_smtp"
  description = "Allow MTA inbound SMTP traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "SMTP from MTA"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mta_smtp"
  }
}

resource "aws_security_group" "lappland_santa_mta_smtps" {
  name        = "lappland_santa_mta_smtps"
  description = "Allow MTA inbound SMTPS traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "SMTP from MTA"
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mta_smtps"
  }
}

resource "aws_security_group" "lappland_santa_mta_tls" {
  name        = "lappland_santa_mta_tls"
  description = "Allow MTA inbound TLS traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "TLS from MTA"
    from_port   = 587
    to_port     = 587
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mta_tls"
  }
}

resource "aws_security_group" "lappland_santa_mua_imaps" {
  name        = "lappland_santa_mua_imaps"
  description = "Allow MUA inbound IMAPS traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "IMAPS from MUA"
    from_port   = 993
    to_port     = 993
    protocol    = "tcp"
    cidr_blocks = split(",", var.mail_clients)
  }

  tags = {
    Name = "allow_mua_imaps"
  }
}

resource "aws_security_group" "lappland_santa_web_http" {
  name        = "lappland_santa_web_http"
  description = "Allow web inbound HTTP traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "HTTP for web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_http"
  }
}

resource "aws_security_group" "lappland_santa_web_https" {
  name        = "lappland_santa_welappland_santa_web_httpsb_https"
  description = "Allow web inbound HTTPS traffic"
  vpc_id      = aws_vpc.lappland.id

  ingress {
    description = "HTTPS for web"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_https"
  }
}

resource "aws_key_pair" "lappland_santa_key" {
  key_name_prefix = split(":", var.TF_VAR_ssh_key)[0]
  public_key      = split(":", var.TF_VAR_ssh_key)[1]
  tags = {
    user = split(":", var.TF_VAR_ssh_key)[0]
  }
}

resource "aws_instance" "lappland_santa" {
  ami           = "ami-830c9e4e3"
  instance_type = "t3a.micro"
  vpc_security_group_ids = [
    aws_security_group.lappland_santa_wireguard.id,
    aws_security_group.lappland_santa_ssh.id,
    aws_security_group.lappland_santa_mta_smtp.id,
    aws_security_group.lappland_santa_mta_smtps.id,
    aws_security_group.lappland_santa_mta_tls.id,
    aws_security_group.lappland_santa_mua_imaps.id,
    aws_security_group.lappland_santa_web_http.id,
    aws_security_group.lappland_santa_web_http.id
  ]
  subnet_id                             = aws_subnet.lappland.id
  instance_initiated_shutdown_behaviour = "terminate"
  ipv6_address_count                    = 0
  key_name                              = aws_key_pair.lappland_santa_key.key_name

  ebs_block_device = {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    encrypted             = false
    volume_size           = 30
  }

  tags = {
    Name         = var.server_name
    LapplandType = "lappland-santa"
  }
}

resource "aws_eip" "lappland_ip" {
  vpc        = true
  instance   = aws_instance.lappland_santa.id
  depends_on = [aws_internet_gateway.lappland_gateway]
}

output "external_ip" {
  value = aws_eip.lappland_ip.public_ip
}
