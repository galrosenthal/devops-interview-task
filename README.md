# DevOps Hands-On Interview Task

Welcome to the DevOps interview exercise!

You have SSH access to a pre-provisioned EC2 instance where you'll perform a series of tasks based on a basic Flask app.

## 🧪 Your Objectives:

1. **Clone your fork of this repo onto the EC2 instance**
2. **Dockerize** the app in `/app` (build and run it)
3. **Write Kubernetes manifests** to deploy the app
4. (Optional) Set up a CI/CD pipeline
5. (Optional) Add monitoring integration (e.g., Prometheus or Datadog)

## 📁 Folder Structure

```text
/app                 # Flask app with Dockerfile
/k8s                 # Kubernetes manifests (deployment, service)
/.github/workflows   # CI/CD pipeline (optional)
```

## ✅ Deliverables
- A running containerized app
- Kubernetes YAMLs in `/k8s`
- (Optional) working GitHub Actions workflow

Have fun and show off your DevOps chops!
