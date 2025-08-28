# --- Amazon ECR Repository ---
# This resource creates a new private ECR repository to store Docker container images.

resource "aws_ecr_repository" "app_repository" {
  name = var.app_name

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    "Name" = var.app_name
    "DeploymentMode" = var.deployment_mode
    "Project" = var.project_slug
    "ManagedBy" = "app_platform"
  }
}

# --- ECR Lifecycle Policy ---
# This resource attaches a policy to the ECR repository to automatically manage and
# clean up old images, which helps control storage costs.

resource "aws_ecr_lifecycle_policy" "app_repo_policy" {
  repository = aws_ecr_repository.app_repository.name

  # The policy is defined in JSON format.
  policy = <<-EOT
  {
      "rules": [
          {
              "rulePriority": 1,
              "description": "Expire untagged images older than 14 days",
              "selection": {
                  "tagStatus": "untagged",
                  "countType": "sinceImagePushed",
                  "countUnit": "days",
                  "countNumber": 14
              },
              "action": {
                  "type": "expire"
              }
          },
          {
              "rulePriority": 2,
              "description": "Keep last 20 total images",
              "selection": {
                  "tagStatus": "any",
                  "countType": "imageCountMoreThan",
                  "countNumber": 20
              },
              "action": {
                  "type": "expire"
              }
          }
      ]
  }
  EOT
}


# Find the Route53 zone
data "aws_route53_zone" "my_domain" {
  name = var.base_domain
}

# Find the ALB created by the Helm chart's ingress
data "aws_lb" "app_alb" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.k8s_cluster_name
    "ingress.k8s.aws/stack" = "${var.deployment_mode}/${var.project_slug}"
  }
}

# Create the DNS record
resource "aws_route53_record" "app_cname" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = "${var.project_slug}.${var.deployment_mode}" # e.g., order-service.staging
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.app_alb.dns_name]
}
