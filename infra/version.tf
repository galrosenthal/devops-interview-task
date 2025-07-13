terraform {
  required_version = ">= 1.10.0"
  
  backend "s3" {
    # IMPORTANT: Replace with a unique S3 bucket name.
    # This bucket must exist and be in the same region as your EKS cluster.
    bucket         = "devops-interview-task-bucket-dasjfh9324" # e.g., my-eks-tf-state-12345
    use_lockfile   = true
    key            = "eks/terraform.tfstate" # Path within the S3 bucket for the state file
    region         = "us-east-1"             # Must match your AWS region from variables.tf
    encrypt        = true                    # Encrypt the state file at rest
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a compatible version
    }
  }
}
