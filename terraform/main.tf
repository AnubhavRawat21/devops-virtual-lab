# Terraform AWS Infrastructure as Code (IaC) Configuration
# Virtual Lab Experiment - 5: End-to-End DevOps CI/CD Pipeline

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. DevOps Dedicated VPC
resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "DevOps-CI-CD-VPC"
    Environment = "Lab"
    ManagedBy   = "Terraform"
    Student     = "Anubhav Rawat"
  }
}

# 2. Public Subnet for Compute Nodes
resource "aws_subnet" "devops_public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "DevOps-Public-Subnet"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "DevOps-IGW"
  }
}

# 4. Route Table
resource "aws_route_table" "devops_public_rt" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "DevOps-Public-RouteTable"
  }
}

# 5. Route Table Association
resource "aws_route_table_association" "devops_rta" {
  subnet_id      = aws_subnet.devops_public_subnet.id
  route_table_id = aws_route_table.devops_public_rt.id
}

# 6. Security Group for SSH, HTTP & K8s NodePort
resource "aws_security_group" "devops_sg" {
  name        = "devops-lab-sg"
  description = "Allow SSH, HTTP and NodePort access"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP web access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes NodePort service"
    from_port   = 30080
    to_port     = 30080
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
    Name = "DevOps-SecurityGroup"
  }
}

# 7. EC2 Instance: DevOps-Lab-Server
resource "aws_instance" "devops_server" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2 / Ubuntu LTS
  instance_type          = "t2.micro"
  key_name               = "devops-key"
  subnet_id              = aws_subnet.devops_public_subnet.id
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name        = "DevOps-Lab-Server"
    Role        = "CI-CD-Runner-K8s-Node"
    Environment = "VirtualLab"
  }
}

output "instance_public_ip" {
  description = "Public IP of the provisioned DevOps EC2 server"
  value       = aws_instance.devops_server.public_ip
}

output "vpc_id" {
  description = "VPC ID of DevOps deployment"
  value       = aws_vpc.devops_vpc.id
}
