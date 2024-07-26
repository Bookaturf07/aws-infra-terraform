provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "alb" {
  source = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "elastic_beanstalk" {
  source             = "./modules/elastic_beanstalk"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_security_group = module.alb.alb_security_group_id
  alb_arn            = module.alb.application_lb_arn
}

module "rds" {
  source                = "./modules/rds"
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_security_group_id = module.vpc.rds_security_group_id
}

module "iam" {
  source = "./modules/iam"
}

# Define IAM role for Elastic Beanstalk
resource "aws_iam_role" "beanstalk_role_bookaturf" {
  name = "beanstalk-role-bookaturf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AdministratorAccess policy to beanstalk-role-bookaturf role
resource "aws_iam_policy_attachment" "beanstalk_admin_policy_attachment" {
  name       = "beanstalk-admin-policy-attachment"
  roles      = [
    aws_iam_role.beanstalk_role_bookaturf.name,
    aws_iam_role.bookaturf_role_admin.name
  ]
  users      = [aws_iam_user.harnil_user.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create the bookaturf-role-admin role
resource "aws_iam_role" "bookaturf_role_admin" {
  name = "bookaturf-role-admin"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::533267399683:root"
        }
      }
    ]
  })
}

# Attach AdministratorAccess policy to bookaturf-role-admin role
resource "aws_iam_policy_attachment" "bookaturf_admin_policy_attachment" {
  name       = "bookaturf-admin-policy-attachment"
  roles      = [
    aws_iam_role.bookaturf_role_admin.name,
    aws_iam_role.beanstalk_role_bookaturf.name
  ]
  users      = [aws_iam_user.harnil_user.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Define IAM user 'Harnil'
resource "aws_iam_user" "harnil_user" {
  name = "Harnil"
}

# Attach AdministratorAccess policy to Harnil user
resource "aws_iam_user_policy_attachment" "harnil_admin_access" {
  user       = aws_iam_user.harnil_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}