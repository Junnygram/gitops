```
# GitOps Actions EKS Deployment

This project automates infrastructure provisioning and application deployment to an Amazon EKS cluster using GitHub Actions, Terraform, and Helm.

---

## 📁 Project Structure
```

.
├── .github/workflows/ # CI/CD workflows
│ ├── deploy-on-pr.yml
│ ├── infra-create.yml
│ └── infra-destroy.yml
├── app/ # Next.js application
├── appchart/ # Helm chart for the app
│ ├── Chart.yaml
│ ├── values.yaml
│ └── templates/
├── k8s/ # Optional K8s manifests
├── terraform/ # Infrastructure as Code
│ ├── eks-vpc-ecr.tf
│ ├── main.tf
│ ├── outputs.tf
│ ├── terraform.tf # Backend & providers
│ └── variables.tf

````

---

## 🚀 CI/CD Overview

### `deploy-on-pr.yml`

- Triggered on pull requests to `main`, `staging`, or `develop`.
- Builds and pushes Docker image to Amazon ECR.
- Deploys the app to EKS using Helm.

### `infra-create.yml`

- Provisions EKS, VPC, and ECR using Terraform on merge to main.

### `infra-destroy.yml`

- Destroys the infrastructure manually via workflow dispatch.

---

## 🛠️ Setup

### 1. 🔐 GitHub Secrets

Go to your GitHub repo settings → **Secrets and Variables** → **Actions** → add the following secrets:

| Secret Name             | Description                                                          |
| ----------------------- | -------------------------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | Your AWS access key                                                  |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key                                                  |
| `REGISTRY`              | ECR registry URI (e.g. `1234567890.dkr.ecr.us-east-1.amazonaws.com`) |
| `ECR_REPO`              | Name of your ECR repository                                          |
| `EKS_CLUSTER`           | Your EKS cluster name                                                |
| `BUCKET`                | S3 Bucket lockfile                                                   |
| `AWS_REGION `           | Your Default region                                                  |

---

### 2. 🌐 Terraform Remote State (S3 + DynamoDB)

The backend is configured to use:

- **Region**: `us-east-1`
- **S3 Bucket**: `infrabuckettt-iacgitops-us-east-1`
<!-- - **DynamoDB Table** _(optional but recommended)_: `terraform-locks` -->

> 💡 You must manually create the S3 bucket **before running `terraform init`**.

Use this bootstrap file (run it locally once):

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "infrabuckettt-iacgitops-us-east-1"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}
````

---

## 🧱 Infrastructure

Terraform creates:

- VPC (public/private subnets)
- EKS cluster
- ECR repo
- IAM roles & policies
- Kubernetes resources via Helm

---

## 📦 Application

The app is built with [Next.js](https://nextjs.org) and containerized via Docker.

```bash
# Build locally
docker build -t gitops-webapp .

# Push to ECR manually (if needed)
aws ecr get-login-password | docker login --username AWS --password-stdin <registry>
docker tag gitops-webapp <registry>/gitops-webapp:latest
docker push <registry>/gitops-webapp:latest
```

---

## 🪄 Deploy on PR (How It Works)

1. PR triggers `deploy-on-pr.yml`
2. Builds Docker image and tags with `${{ github.run_number }}`
3. Pushes to ECR
4. Updates EKS via Helm with `appimage` and `apptag` values

---

## 📋 Notes

- Ensure your GitHub Actions runner has IAM permissions to access ECR/EKS/S3.
- Use `terraform apply` with caution — make sure the correct workspace and region are selected.
- To destroy infrastructure, trigger `infra-destroy.yml` from the Actions tab manually.

---

## 🤝 Contributing

Want to improve the pipeline or infrastructure setup? Open a PR or suggest an enhancement!

---

## 📄 License

MIT © Junior Oyewunmi

```

---

```
# -gitops-action
# infra-gitops
# action-ops
# action-ops
# gitops
# gitops
