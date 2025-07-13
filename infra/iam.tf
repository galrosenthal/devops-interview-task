# ------------------------------------------------------------------------------
# IAM Policy for GitHub Actions Terraform Plan
# This policy grants necessary permissions for Terraform to read state from S3,
# manage state locking with DynamoDB, and perform read-only operations for plan.
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "github_actions_terraform_plan_policy" {
  name        = "${var.project_name}-github-actions-tf-plan-policy"
  description = "IAM policy for GitHub Actions to run terraform plan"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "TerraformStateAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_backend_bucket_name}",
          "arn:aws:s3:::${var.s3_backend_bucket_name}/*"
        ]
      },
      {
        Sid = "TerraformPlanReadAccess"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "eks:Describe*",
          "iam:List*",
          "iam:Get*",
          "s3:List*",
          "s3:GetBucketLocation",
          "cloudformation:DescribeStacks",
          "cloudformation:ListStacks",
          "sts:AssumeRole",
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      }
    ]
  })
}

# ------------------------------------------------------------------------------
# IAM Role for GitHub Actions OIDC
# This role trusts the GitHub OIDC provider and allows GitHub Actions to assume it.
# ------------------------------------------------------------------------------
resource "aws_iam_role" "github_actions_terraform_role" {
  name               = "${var.project_name}-github-actions-tf-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            # IMPORTANT: Replace 'your-github-org/your-repo-name' with your actual GitHub organization and repository name.
            # Example: "repo:my-org/my-eks-project:*"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo_owner}/${var.github_repo_name}:*"
          }
        }
      }
    ]
  })

  tags = {
    Project = var.project_name
    ManagedBy = "Terraform"
  }
}

# ------------------------------------------------------------------------------
# Attach the IAM Policy to the IAM Role
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "github_actions_terraform_attachment" {
  role       = aws_iam_role.github_actions_terraform_role.name
  policy_arn = aws_iam_policy.github_actions_terraform_plan_policy.arn
}

# ------------------------------------------------------------------------------
# Data source to get the current AWS account ID
# Required for the OIDC trust policy.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}
