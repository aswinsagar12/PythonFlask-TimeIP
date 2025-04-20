resource "aws_vpc" "particle_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Env"  = "dev",
    "Name" = "particle_vpc"
  }
}

resource "aws_subnet" "public_subnet1" {

  vpc_id                  = aws_vpc.particle_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.particle_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet2"
  }

}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.particle_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private_subnet1"
  }

}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.particle_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet2"
  }

}


resource "aws_internet_gateway" "particle_igw" {
  vpc_id = aws_vpc.particle_vpc.id
  tags = {
    Name = "particle_igw"
  }

}

resource "aws_eip" "particle_eip" {
  domain = "vpc"
  tags = {
    Name = "particle_eip"
  }

}

resource "aws_nat_gateway" "particle_nat" {
  allocation_id = aws_eip.particle_eip.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "particle_nat"
  }

}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.particle_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.particle_igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_assoc1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.particle_vpc.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.particle_nat.id
  }
  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "private_assoc3" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id

}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id

}


