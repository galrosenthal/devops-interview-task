provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------------------------
# VPC Module
# This module creates a VPC, public and private subnets, NAT Gateways,
# Internet Gateway, and route tables.
# ------------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  public_subnets  = var.public_subnets_cidr
  private_subnets = var.private_subnets_cidr

  enable_nat_gateway = true
  single_nat_gateway = true # For minimal setup, single NAT Gateway is sufficient

  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# EKS Cluster Module
# This module creates the EKS cluster, IAM roles, and worker node groups.
# ------------------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.0" # Use a compatible version

  cluster_name                   = "${var.project_name}-cluster"
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets


  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# Data source to get available availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}
