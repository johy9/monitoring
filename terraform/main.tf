resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "docker_sg" {
  vpc_id = aws_vpc.my_vpc.id

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_instance" {
  ami           = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id

  security_groups = [aws_security_group.docker_sg.id]
  key_name = "red"
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo usermod -aG docker ubuntu
    EOF

  tags = {
    Name = "docker-instance"
  }
}

resource "docker_container" "container1" {
  name  = "container1"
  image = "ubuntu:latest"  
}

resource "docker_container" "container2" {
  name  = "container2"
  image = "debian:latest" 
}