# 🧪 DevOps Technical Task – Hands-On Assessment

This task simulates a real-world microservice deployment flow. It is designed to evaluate your familiarity with Docker, Kubernetes, Terraform, CI/CD, and AWS.

Please complete the task on your provided EC2 instance, and this forked repository.

---

## 🧱 Stage 1: Dockerize the Application
- You are given a simple Python Flask application in the `/app` directory.
- Create a Dockerfile to containerize the app.
- Build and run it locally using Docker.
- Ensure it responds on port 5000 with a simple JSON response.

### Deliverables:
- `Dockerfile`
- `docker run` test results (screenshot or log)
- `curl` output (screenshot or log)

### 🔁 CI/CD Step 1: Build & Push Docker Image
- Create a GitHub Actions workflow that:
  - Builds the Docker image
  - Pushes it to DockerHub, GitHub Packages, or Amazon ECR

### Deliverables:
- `.github/workflows/docker-build.yml`
- Link to the image or output of a successful build

---

## ☁️ Stage 2: Infrastructure with Terraform
- Create a minimal EKS cluster using Terraform.
- Provision required IAM roles, VPC, subnets, and worker nodes.
- Output the cluster name and kubeconfig path or instructions to access it.

### Deliverables:
- Terraform configuration under `/infra`
- Documented instructions in a README

> 💡 Bonus: Use official Terraform AWS modules (e.g., `terraform-aws-modules/eks/aws`)

### 🔁 CI/CD Step 2: Terraform Plan Verification
- Add a GitHub Actions workflow that:
  - Validates the Terraform code
  - Runs `terraform init` and `terraform plan`

### Deliverables:
- `.github/workflows/terraform-validate.yml`

---

## 🐳 Stage 3: Deploy to Kubernetes
- Write Kubernetes manifests (Deployment + Service) for the Flask app
- Deploy it to the EKS cluster
- Expose it using a LoadBalancer or Ingress (your choice)
- Validate that it's reachable via HTTP

### Deliverables:
- Manifests under `/k8s`
- Screenshot or `curl` output from the service URL

### 🔁 CI/CD Step 3: Deploy to EKS
- Extend your GitHub Actions workflow to:
  - Use `kubectl` to apply the manifests
  - Ensure it targets the correct cluster and namespace

### Deliverables:
- `.github/workflows/deploy.yml`
- Instructions or configuration for kubeconfig access

---

## 🔎 Stage 4: Observability (Bonus)
- Add basic logging or monitoring
- You can use:
  - CloudWatch Logs
  - Prometheus + Grafana
  - EKS control plane metrics (if enabled)

### Deliverables:
- Screenshot or sample dashboard

---

## ✅ Evaluation Criteria
- Clear understanding of each tool (Docker, Terraform, K8s, AWS)
- Ability to write working IaC and manifests
- CI/CD best practices
- Proper use of security, IAM, and networking
- Documentation

---

📝 **Note**: Don’t aim for perfection. We want to see how you think, troubleshoot, and structure your work.

Good luck 🚀
