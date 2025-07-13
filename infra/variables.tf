variable "aws_region" {
  description = "AWS region for the EKS cluster"
  type        = string
  default     = "us-east-1" # You can change this to your desired region
}

variable "project_name" {
  description = "Name of the project, used as a prefix for resources"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29" # Specify your desired Kubernetes version
}

variable "instance_types" {
  description = "List of instance types for the EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"] # Adjust instance type based on your needs
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "github_repo_owner" {
  description = "GitHub organization or user name that owns the repository"
  type        = string
  # IMPORTANT: Replace with your GitHub organization/user name
  default     = "galrosenthal"
}

variable "github_repo_name" {
  description = "GitHub repository name where the workflow will run"
  type        = string
  # IMPORTANT: Replace with your GitHub repository name
  default     = "devops-interview-task"
}
variable "s3_backend_bucket_name" {
  description = "Name of the S3 bucket used for Terraform state backend"
  type        = string
  # IMPORTANT: Default should match the bucket name in infra/backend.tf
  default     = "devops-interview-task-bucket-dasjfh9324"
}
