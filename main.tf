# Provider Block
provider "aws" {
  region = var.webserver_region
  access_key = var.webserver_access_key
  secret_key = var.webserver_secret_key
}

 # Create vpc
resource "aws_vpc" "priv-vpc" {
  cidr_block = var.webserver_vpc_block

  tags = {
    "Name" = "private"
  } 
}

 # Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.priv-vpc.id

  tags = {
    "Name" = "Gateway"
  } 
}

 # Create Custom Route Table
resource "aws_route_table" "routing" {
  vpc_id = aws_vpc.priv-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Routing"
  }
}

 # Create a Subnet
resource "aws_subnet" "subnet-01" {
  vpc_id     = aws_vpc.priv-vpc.id
  cidr_block = var.webserver_subnet_block
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet"
  }
}

 # Associate Subnet with Route Table
resource "aws_route_table_association" "asst" {
  subnet_id      = aws_subnet.subnet-01.id
  route_table_id = aws_route_table.routing.id
}

 # Create Security Group to allow port 22, 80, 44
resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.priv-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_traffic"
  }
}

 # Create a Network Interface with an IP in the subnet that was created in step 4
 resource "aws_network_interface" "web-server" {
  subnet_id       = aws_subnet.subnet-01.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_traffic.id]

}
 
 # Assign an Elastic IP to the network interface created in step 7
 resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}
 
 # Create an Ubuntu Server and install apache2 (then enable the apache2 service)
 resource "aws_instance" "web-server-instance" {
   ami = "ami-042e8287309f5df03"
   instance_type = var.webserver_instanceType
   availability_zone = "us-east-1a"
   key_name = "terraform-key"

   network_interface {
     device_index = 0
     network_interface_id = aws_network_interface.web-server.id
   }

    user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello from Webserver at instance id `curl http://169.254.169.254/latest/meta-data/instance-id` </h1></body></html>" > /var/www/html/index.html
      EOF
    tags = {
      "Name" = "web-server"
    }

 }


