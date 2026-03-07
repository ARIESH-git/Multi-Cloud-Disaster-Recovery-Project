terraform {
  backend "s3" {
    bucket         = "multi-cloud-tf-state"
    key            = "aws/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "multi-cloud-tf-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "key" {
  key_name   = "multi-cloud-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/multi-cloud-key.pem"
  file_permission = "0400"
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet1_cidr  = var.public_subnet1_cidr
  public_subnet2_cidr  = var.public_subnet2_cidr
  private_subnet1_cidr = var.private_subnet1_cidr
  private_subnet2_cidr = var.private_subnet2_cidr
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key.key_name
  subnet_id     = module.vpc.public_subnet1_id
  sg_id         = module.security_group.sg_id
}
