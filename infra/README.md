Minimal AWS EKS Cluster with Terraform
This project provides a Terraform configuration to provision a minimal Amazon Elastic Kubernetes Service (EKS) cluster on AWS. It includes the necessary infrastructure components such as VPC, subnets, IAM roles, and worker nodes.

Deliverables
/infra directory: Contains all Terraform configuration files.

README.md (this file): Provides detailed instructions for deployment and access.

Prerequisites
Before you begin, ensure you have the following installed and configured:

AWS CLI: Configured with credentials that have sufficient permissions to create EKS clusters, VPCs, IAM roles, etc.

Install: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Configure: aws configure

Terraform: Version 1.0.0 or higher.

Install: https://developer.hashicorp.com/terraform/downloads

kubectl: Kubernetes command-line tool.

Install: https://kubernetes.io/docs/tasks/tools/install-kubectl/

Project Structure
.
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── versions.tf
│   └── outputs.tf
└── README.md

Deployment Steps
Follow these steps to deploy the EKS cluster using Terraform:

Navigate to the Terraform directory:

cd infra

Initialize Terraform:
This command downloads the necessary providers and modules.

terraform init

Review the plan (Optional but Recommended):
This command shows you what Terraform will create, modify, or destroy.

terraform plan

Review the output carefully to ensure it aligns with your expectations.

Apply the Terraform configuration:
This command provisions the resources in your AWS account. You will be prompted to confirm the action by typing yes.

terraform apply

This process can take 15-20 minutes as EKS cluster creation is time-consuming.

Accessing the EKS Cluster
Once terraform apply completes successfully, you can access your EKS cluster using kubectl.

Update your Kubeconfig:
Terraform outputs a command to update your kubeconfig file. Copy and paste the output of kubeconfig_command from the terraform apply output. It will look something like this:

aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster-cluster

Replace us-east-1 with your chosen AWS region and my-eks-cluster-cluster with your actual cluster name if you changed the project_name variable.

Verify Cluster Access:
After updating your kubeconfig, you can verify that kubectl can connect to your cluster:

kubectl get svc
kubectl get nodes

You should see the Kubernetes services and your worker nodes listed.

Cleanup
To destroy all the resources created by Terraform, follow these steps:

Navigate to the Terraform directory:

cd infra

Destroy the resources:
This command will tear down all the AWS resources provisioned by this Terraform configuration. You will be prompted to confirm the action by typing yes.

terraform destroy

This will remove the EKS cluster, worker nodes, VPC, subnets, and associated IAM roles.

Customization
You can customize the cluster by modifying the variables.tf file:

aws_region: Change the AWS region.

project_name: Customize the prefix for all resources.

cluster_version: Specify a different Kubernetes version.

instance_types: Choose different EC2 instance types for worker nodes.

desired_size, max_size, min_size: Adjust the scaling properties of the worker node group.

vpc_cidr, public_subnets_cidr, private_subnets_cidr: Modify the network configuration.
