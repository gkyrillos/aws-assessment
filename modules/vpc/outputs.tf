output "ecs_security_group_id" {
  value       = aws_security_group.ecs_sg.id
  description = "The ID of the security group for ECS tasks"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "The ID of the public subnet"
}
