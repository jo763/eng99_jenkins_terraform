# Let Terraform know who is our cloud provider

# AWS plugins/dependencies will be downloaded
provider "aws"{
  region = var.region
  # Allow TF to create services in Ireland

}

# Let's start with launching an EC2 instance using TF
resource "aws_instance" "app_instance" {
  ami = var.app_ami_id
  instance_type = var.app_instance_type
  # Enable public IP
  associate_public_ip_address = true
  # added eng99.pem so one can ssh
  # Ensure we have this key in the .ssh folder
  key_name = var.aws_key_name
  tags = {
    Name = "eng99_joseph_terraform_app"
  }
}

resource "aws_instance" "db_instance" {
  ami = var.app_ami_id
  instance_type = var.app_instance_type
  # Enable public IP
  associate_public_ip_address = false
  # added eng99.pem so one can ssh
  # Ensure we have this key in the .ssh folder
  key_name = var.aws_key_name
  tags = {
    Name = "eng99_joseph_terraform_db"
  }
}

resource "aws_vpc" "eng99_joseph_terraform_VPC"{
  cidr_block = var.cidr_block

  tags = {
    Name = "eng99_joseph_terraform_VPC"
  }
}

resource "aws_subnet" "eng99_joseph_terraform_public_SN" {
  vpc_id     = aws_vpc.eng99_joseph_terraform_VPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"

  tags = {
    Name = "eng99_joseph_terraform_public_SN"
  }
}

resource "aws_internet_gateway" "eng99_joseph_terraform_igw" {
  vpc_id = aws_vpc.eng99_joseph_terraform_VPC.id

  tags = {
    Name = "eng99_joseph_terraform_igw"
  }
}

resource "aws_route_table" "eng99_joseph_terraform_rt" {
  vpc_id = aws_vpc.eng99_joseph_terraform_VPC.id

  route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.eng99_joseph_terraform_igw.id
    }

  tags = {
    Name = "eng99_joseph_terraform_rt"
  }
}

resource "aws_route_table_association" "eng99_joseph_terraform_subnet_associate" {
  route_table_id = aws_route_table.eng99_joseph_terraform_rt.id
  subnet_id = aws_subnet.eng99_joseph_terraform_public_SN.id
}
// module "vpc" {
//   source = "terraform-aws-modules/vpc/aws"
//
//   name = "eng99_joseph_terraform_VPC"
//   cidr = var.cidr_block
//
//   azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
//   private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
//   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
//
//   enable_nat_gateway = false
//   enable_vpn_gateway = false
//
//   tags = {
//     Terraform = "true"
//     Environment = "dev"
//   }
// }
# To intialise we use terraform init
# terraform plan
# terraform apply
# terraform destroy

# Allow port http 80
# allow port all 3000
# allows port 22 to all or own ip
# Inbound rules are called ingress
# Outbound are called egress
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.eng99_joseph_terraform_VPC.id

  ingress {
    description      = "Allow public access"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ssh public access UNSECURE"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ENTER THROUGH ANYWHERE VERY UNSECURE!!!!!"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # allow all
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
