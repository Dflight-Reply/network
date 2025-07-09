terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

data "aws_eks_cluster_auth" "demo" {
  name = aws_eks_cluster.demo-dflight-cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.demo-dflight-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.demo-dflight-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.demo.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.demo-dflight-cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.demo-dflight-cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.demo-dflight-cluster.name, "--profile", "storm-roma-lab"]
      command     = "aws"
    }
  }
}