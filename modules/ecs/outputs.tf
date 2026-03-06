output "task_definition_arn" {
  value       = aws_ecs_task_definition.sns_task.arn
  description = "The ARN of the ECS task definition"
}
