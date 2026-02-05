#vpc creation
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  tags = {
    Name = "VPC"
  }
}

#private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone =  "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Private_Subnet"
  }
}



#public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone =  "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
  
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg1" {
  name        = "security_group1"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.myvpc.id
  

  ingress {
    description = "TLS From VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tighten later
  }
  ingress {
    description = "HTTP From VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # tighten later
  } 
   tags = {
    Name = "web-sg"
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = "praveenterraform2025"
}


resource "aws_instance" "web3" {
  ami           = "ami-04df1508c6be5879e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  key_name = "brucelee02"
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.sg1.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = (file("user_data.sh"))
  tags = {
    Name = "WEB1"
  }
}


resource "aws_instance" "web2" {
  ami           = "ami-04df1508c6be5879e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_subnet.id
  key_name = "brucelee02"
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.sg1.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = (file("user_data.sh"))
  tags = {
    Name = "WEB2"
  }
}


resource "aws_lb" "alb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets            = [aws_subnet.private_subnet.id , aws_subnet.public_subnet.id]

  enable_deletion_protection = true

}

resource "aws_lb_target_group" "tg" {
  name     = "mytg"
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
  target_id        = aws_instance.web3.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "test2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_listener" "lisenter" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg.id
    }
  
}

output "loadbalancer" {
    value = aws_lb.alb.dns_name

  
}

resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "ec2-s3-access-policy"
  description = "Allow EC2 to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::praveenterraform2025"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::praveenterraform2025/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}


