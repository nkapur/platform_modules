output "ecr_repository_url" {
  description = "The URL of the created ECR repository."
  value       = aws_ecr_repository.app_repository.repository_url


output "ecr_repository_name" {
  description = "The name of the ECR repository."
  value       = aws_ecr_repository.app_repository.name
}

