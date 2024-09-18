# Define variables
variable "DBNameP" {
  type    = string
}

variable "MUser" {
  type    = string
}

variable "MPass" {
  type    = string
}

variable "AWSRegion" {
  type    = string
  default = "us-east-2a"
}

variable "KEY" {
  type        = string
  description = "Choosing the Key Pair"
  default     = "london-krish"
}

# Create EC2 instance
resource "aws_instance" "InstanceNode" {
  ami           = "ami-07650ecb0de9bd731"
  instance_type = "t3.micro"
  key_name      = var.KEY
  user_data     = <<-EOT
    #!/bin/bash -xe
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello, World!" > /var/www/html/index.html
  EOT

  security_group = aws_security_group.InstanceNodeSG.id
}

# Create security group
resource "aws_security_group" "InstanceNodeSG" {
  name        = "InstanceNodeSG"
  description = "Enable SSH and HTTP"

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
}


# Retrieve availability zones
data "aws_availability_zones" "available" {}

# Output values
output "InstanceId" {
  description = "EC2 Instance ID"
  value       = aws_instance.InstanceNode.id
}

output "InstancePublicIP" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.InstanceNode.public_ip
}

output "VpcId" {
  description = "VPC ID"
  value       = aws_instance.InstanceNode.vpc_id
}

output "InternetGatewayId" {
  description = "Internet Gateway ID"
  value       = aws_instance.InstanceNode.vpc_id
}

output "Subnet1Id" {
  description = "Subnet 1 ID"
  value       = aws_instance.InstanceNode.subnet_id
}

output "Subnet2Id" {
  description = "Subnet 2 ID"
  value       = aws_instance.InstanceNode.subnet_id
}

output "RouteTableId" {
  description = "Route Table ID"
  value       = aws_instance.InstanceNode.vpc_id
}

output "SecurityGroupId" {
  description = "Security Group ID"
  value       = aws_security_group.InstanceNodeSG.id
}
