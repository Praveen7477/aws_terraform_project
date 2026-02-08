resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Production VPC"
  }
}

resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "Public Subnet 1"
  }
}
resource "aws_subnet" "pub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "Public Subnet 2"
  }
}
resource "aws_subnet" "priv1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "Private Subnet 1"
  }
}
resource "aws_subnet" "priv2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "Private Subnet 2"
  }
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.myvpc.id
  # ... other configuration ...
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-sg"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "web1" {
  ami           = "ami-04df1508c6be5879e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.priv1.id
  key_name = "brucelee02"
  security_groups = [aws_security_group.sg.id]
  user_data = (file("user_data.sh"))


  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "web2" {
  ami           = "ami-04df1508c6be5879e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.priv2.id
  key_name = "brucelee02"
  security_groups = [aws_security_group.sg.id]
  user_data = (file("user_data1.sh"))


  tags = {
    Name = "web2"
  }
}

resource "aws_instance" "web3" {
  ami           = "ami-04df1508c6be5879e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.pub1.id
  key_name = "brucelee02"
  security_groups = [aws_security_group.sg.id]
  associate_public_ip_address = "true"


  tags = {
    Name = "Bastion-Host"
  }
}


resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "examp" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub1.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}


resource "aws_route_table" "privrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.examp.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "rt3" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.privrt.id
}

resource "aws_route_table_association" "rt4" {
  subnet_id      = aws_subnet.priv2.id
  route_table_id = aws_route_table.privrt.id
}


resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.pub1.id, aws_subnet.pub2.id ]

  enable_deletion_protection = true
}

resource "aws_lb_target_group" "tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "test1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_listener" "lisenter" {
    load_balancer_arn = aws_lb.test.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
  
}
