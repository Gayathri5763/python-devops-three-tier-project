resource "aws_vpc" "padma" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "trm_prj"
    }
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.padma.id
    tags = {
      Name = "trm_igw"
    }
  
}
resource "aws_subnet" "public_subnet-01" {
    vpc_id = aws_vpc.padma.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "prj-pub-sub-1"
    }
  
}
resource "aws_subnet" "public_subnet-02" {
  vpc_id = aws_vpc.padma.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "prj-pub-sub-2"
  }
}
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.padma.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name = "prj-rt"
    }
  
}
resource "aws_route_table_association" "rt-association-01" {
    route_table_id = aws_route_table.rt.id
    subnet_id = aws_subnet.public_subnet-01.id
  
}
resource "aws_route_table_association" "rt-association-02" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.public_subnet-02.id
}
resource "aws_security_group" "security-group" {
  vpc_id      = aws_vpc.padma.id
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress = [
    for port in [22, 8080, 9000, 9090, 80] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "py-sg"
  }
}