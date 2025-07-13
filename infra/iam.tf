# infra/iam.tf

# ------------------------------------------------------------------------------
# IAM OpenID Connect Provider for GitHub Actions
# This resource registers GitHub's OIDC URL with AWS, allowing AWS to trust
# identity tokens issued by GitHub Actions. This is a one-time setup per AWS account.
# ------------------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url = "https://token.actions.githubusercontent.com"

  # The thumbprint is a hash of the root CA certificate of the OIDC provider.
  # This value is stable for GitHub's OIDC provider.
  # You can verify the current thumbprint by running:
  # openssl s_client -servername token.actions.githubusercontent.com -showcerts -connect token.actions.githubusercontent.com:443 < /dev/null | openssl x509 -fingerprint -noout
  thumbprint_list = ["6938fd485d156ee2930aa495293b5ea00037bd39"] # As of 2023-10-26, this is the current thumbprint. Verify if needed.

  client_id_list = ["sts.amazonaws.com"]

  tags = {
    Project = var.project_name
    ManagedBy = "Terraform"
    Purpose = "GitHubActionsOIDC"
  }
}

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
          "kms:Describe*",
          "kms:Get*",
          "logs:Describe*",
          "logs:List*",
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
          Federated = aws_iam_openid_connect_provider.github_oidc.arn # Reference the created OIDC provider
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

