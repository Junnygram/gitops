terraform {
  required_version = "~> 1.0"
  backend "s3" {
    bucket = "infrabuckettt-iacgitops-us-east-1"
    key    = "gitops-actions/state.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
  }
}

