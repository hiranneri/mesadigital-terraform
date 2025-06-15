resource "aws_vpc" "mesadigital_vpc_1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "mesadigital_vpc_1"
  }
}

resource "aws_subnet" "mesadigital_subnet_pub" {
  vpc_id                  = aws_vpc.mesadigital_vpc_1.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "mesadigital_subnet_pub_1"
  }
}

resource "aws_subnet" "mesadigital_subnet_priv" {
  vpc_id                  = aws_vpc.mesadigital_vpc_1.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "mesadigital_subnet_priv_1"
  }
}

resource "aws_internet_gateway" "mesadigital_igw" {
  vpc_id = aws_vpc.mesadigital_vpc_1.id

  tags = {
    "Name" = "mesadigital_igw"
  }
}

resource "aws_route_table" "mesadigital_route_table_pub" {
  vpc_id = aws_vpc.mesadigital_vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mesadigital_igw.id
  }

  tags = {
    "Name" = "mesadigital_route_table_pub"
  }
}

resource "aws_route_table" "mesadigital_route_table_priv" {
  vpc_id = aws_vpc.mesadigital_vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mesadigital_natgateway.id
  }

  tags = {
    "Name" = "mesadigital_route_table_priv"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.mesadigital_subnet_pub.id
  route_table_id = aws_route_table.mesadigital_route_table_pub.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.mesadigital_subnet_priv.id
  route_table_id = aws_route_table.mesadigital_route_table_priv.id
}

resource "aws_eip" "nat_gateway_eip" {
  vpc = true

  tags = {
    Name = "EIP-mesadigital_natgateway"
  }
}

resource "aws_nat_gateway" "mesadigital_natgateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.mesadigital_subnet_priv.id

  tags = {
    Name = "mesadigital_natgateway"
  }

  depends_on = [aws_internet_gateway.mesadigital_igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mesadigital_vpc_1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mesadigital_natgateway.id
  }

  tags = {
    Name = "mesadigital_route_table_priv_associacao"
  }
}

resource "aws_instance" "mesadigital_ec2_1" {
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mesadigital_keypair.id
  vpc_security_group_ids = [aws_security_group.mesadigital_security_group_pub.id]
  subnet_id              = aws_subnet.mesadigital_subnet_pub.id

  ami = data.aws_ami.mesadigital_ami.id

  root_block_device {
    volume_size = 0
  }

  tags = {
    Name = "mesadigital_ec2"
  }

  user_data = file("userdata.tpl")

}


