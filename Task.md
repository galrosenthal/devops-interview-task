# 🧪 DevOps Technical Task

Welcome to the technical task. This interview is designed to evaluate your ability to work with DevOps tools and processes entirely within a controlled EC2 environment — no cloud deployment required.

You will be provided with a dedicated EC2 instance that already has Docker, Kubernetes (via minikube), Terraform, and Git installed. You will complete all steps on this machine and commit your work to your GitHub fork.

---

## ✅ Goal
Build, containerize, simulate deployment, and demonstrate a CI/CD approach using local tools.

---

## 📦 Stage 1: Dockerize the Application
- A simple Flask app is located in the `/app` directory.
- Create a `Dockerfile` to containerize it.
- Build the image and run it locally.
- Validate it's serving HTTP on port 5000.

**Deliverables:**
- `Dockerfile`
- Output of successful `docker build` and `docker run`
- `curl http://localhost:5000` result or similar proof

---

## ☸️ Stage 2: Deploy to Local Kubernetes
- Use [`minikube`](https://minikube.sigs.k8s.io/) (already installed) to create a local K8s cluster.
- Write Kubernetes manifests:
  - Deployment for the app
  - Service (ClusterIP or NodePort)
- Apply the manifests using `kubectl`.

**Deliverables:**
- YAML files in `/k8s`
- `kubectl get pods`, `kubectl get svc` output
- `curl` output to exposed service

---

## 🌍 Stage 3: Local Terraform Simulation
- Write a Terraform configuration to simulate infrastructure creation:
  - Use `kubernetes` provider and deploy the k8s manifests using it
  - Use variables, outputs, and modules where appropriate
- Run `terraform init`, `plan`, and (optionally) `apply`

**Deliverables:**
- Files in `/infra`
- Terminal output of plan/apply

---

## 🔁 Stage 4: Simulate CI/CD Pipeline - Optional
Pick **one** of the following approaches:

### Option A: GitHub Actions (preferred)
- Create `.github/workflows/local-deploy.yml`
- Steps should include:
  - Lint `Dockerfile` or YAML
  - Build the Docker image
  - Echo “Deploying to Kubernetes…” (mock step)

### Option B: Shell-based Pipeline
- Create `ci.sh` or `Makefile`
- Automate the following:
  - Linting
  - Docker build
  - Kubernetes deployment

**Deliverables:**
- CI/CD config (YAML or script)
- Output or screenshots of run results

---

## ✅ Evaluation Criteria
- Clear Docker and K8s setup
- Effective local Terraform use
- Clean file structure and documentation
- Git commit clarity and logical progression
- Understanding of CI/CD concepts

---

Good luck and have fun! 🚀
