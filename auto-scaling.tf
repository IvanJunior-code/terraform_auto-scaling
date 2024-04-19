resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "autoscaling_group"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier  = [aws_subnet.subnet_1a.id, aws_subnet.subnet_1b.id]
  depends_on           = [aws_vpc.vpc_terraform]

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  timeouts {
    delete = "15m"
  }

}



###################### Launch Template ######################
resource "aws_launch_template" "launch_template" {
  name = "launch_template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = false
  disable_api_termination = false

  ebs_optimized = true

  image_id = "ami-0f9b57fe51681be3f"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.small"

  key_name = var.key_name

  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-east-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

}
###################### ###### ######## ######################












###################### VPC ######################
resource "aws_vpc" "vpc_terraform" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "VPC"
  }
}
###################### ### ######################


###################### Subnet ######################
resource "aws_subnet" "subnet_1a" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.subnet_cidr_block[0]
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet 1a"
  }

}

resource "aws_subnet" "subnet_1b" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.subnet_cidr_block[1]
  availability_zone       = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet 1b"
  }

}
###################### ###### ######################