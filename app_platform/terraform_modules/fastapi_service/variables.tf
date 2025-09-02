variable "app_name" {
  description = "The name of the application (e.g., 'order_service'). Used for ECR repo naming."
  type        = string
}

variable "project_slug" {
  description = "The slug for the project (e.g., 'order-service'). Used for DNS and resource naming."
  type        = string
}

variable "deployment_mode" {
  description = "The deployment environment (e.g., 'staging' or 'prod')."
  type        = string
}

variable "base_domain" {
  description = "The base domain name (e.g., 'navneetkapur.com')."
  type        = string
}

variable "k8s_cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "chart_name" {
  description = "The name of the Helm chart."
  type        = string
  default     = "fastapi-service"
}