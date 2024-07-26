resource "aws_elastic_beanstalk_application" "app" {
  name = "bookaturf-app"
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "bookaturf-prod-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.4 running Docker"

  # Configure settings
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  # For Elastic Beanstalk environments, environment variables should be set like this
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "VAR_NAME"
    value     = "VAR_VALUE"
  }

  # Specify the IAM instance profile to use for the environment's EC2 instances
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "bookaturf-role-admin"  # Use the name of the instance profile
  }

  # No direct support for load_balancer_arn, vpc_id, subnet_ids, or security_groups
  # Use the AWS Elastic Beanstalk console or CLI to manage these settings
}