terraform {
  # This tells Terraform the minimum version required to run this module.
  required_version = ">= 1.3.2"

  # This block specifies the required providers and their versions.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}