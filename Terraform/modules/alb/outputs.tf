output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "target_group_blue_arn" {
  value = aws_lb_target_group.blue.arn
}

output "target_group_green_arn" {
  value = aws_lb_target_group.green.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ecs_tasks_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}


output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "https_listener_arn" {
  value = try(aws_lb_listener.https[0].arn, null)
}

output "target_group_blue_name" {
  value = aws_lb_target_group.blue.name
}

output "target_group_green_name" {
  value = aws_lb_target_group.green.name
}

output "test_listener_arn" {
  value = aws_lb_listener.test.arn
}
