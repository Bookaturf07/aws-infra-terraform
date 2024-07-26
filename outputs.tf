output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_arn" {
  value = module.alb.application_lb_arn
}

output "beanstalk_endpoint" {
  value = module.elastic_beanstalk.endpoint
}

output "rds_endpoint" {
  value = module.rds.endpoint
}
