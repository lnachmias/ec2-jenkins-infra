
#Creates Security group
resource "aws_security_group" "terraform_SG" {
  name        = "Jenkins"
  description = "Allow ports for Jenkins access and SSH connectivity"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Jenkins Web Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Port"
    from_port   = 22
    to_port     = 22
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
    Name = "terraform_SG"
    Terraform = "true"
  }
}

# Creation of an AMI machine
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
# resource block
resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.medium"
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.terraform_SG.id]
  key_name        = "mobileye-eu-west2"
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("install-script.sh")}"
  iam_instance_profile = "Jenkins_ECR"
  tags = {
    "Name" = "Linux-Jenkins"
  }

  # Root disk
  root_block_device {
    volume_size           = var.linux_root_volume_size
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
}

