output "application_lb_arn" {
  value = aws_lb.application.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}
