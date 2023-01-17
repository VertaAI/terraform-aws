output "role_arn" {
  description = "ARN of Verta IAM role"
  value       = aws_iam_role.role.arn
}
