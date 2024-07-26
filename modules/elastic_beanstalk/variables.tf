variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ec2_security_group" {
  description = "EC2 security group ID for Elastic Beanstalk instances"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Elastic Beanstalk is deployed"
  type        = string
}
