provider "aws" {
  region = var.aws_region  
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "kafka_sg" {
  name_prefix = "web-sg-"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "kafka_broker"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    self        = true
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "kafka_controller"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    self        = true
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kafka"
    Purpose = "dkedu"
    Stack = "kafka1"
  }
}

resource "aws_launch_template" "kafka_brokers" {
  name = "kafka_brokers"
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name               = "cks"

  vpc_security_group_ids = ["${aws_security_group.kafka_sg.id}"]

  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "kafka_broker"
        Role = "kafka_broker"
        Purpose = "dkedu"
        Stack = "kafka1"
      }
  }
}

resource "aws_autoscaling_group" "kafka_brokers" {
  name = "kafka_brokers"
  desired_capacity     = var.amount_of_brokers
  min_size             = var.amount_of_brokers
  max_size             = var.amount_of_brokers

  launch_template {
    id      = aws_launch_template.kafka_brokers.id
    version = "$Latest"
  }

  vpc_zone_identifier = data.aws_subnets.default.ids
}
