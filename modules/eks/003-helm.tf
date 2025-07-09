resource "helm_release" "aws_load_balancer_controller" {
  name       = "${var.ProjectName}-cluster-aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.11.0"
  namespace  = "kube-system"


  set {
    name  = "clusterName"
    value = "${var.ProjectName}-cluster"
  }

  set {
    name  = "image.tag"
    value = "v2.11.0"
  }

  set {
    name  = "image.repository"
    value = "public.ecr.aws/eks/aws-load-balancer-controller"
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "region"
    value = "eu-south-1"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "${var.ProjectName}-cluster-aws-load-balancer-controller-sa"
  }


  set {
    name  = "enableWaf"
    value = false
  }

  set {
    name  = "enableWafv2"
    value = true
  }
  set {
    name  = "enableShield"
    value = false
  }

  depends_on = [
    aws_eks_access_policy_association.current_association,
    aws_eks_node_group.demo-dflight-node-group
  ]
}

resource "aws_iam_role" "lb-controller-role" {
  name = "lb-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Sid    = "PodsEks"
        Principal = {
          Service = [
            "pods.eks.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lb_policy_attachment" {
  policy_arn = aws_iam_policy.aws_loadbalancer_controller.arn
  role       = aws_iam_role.lb-controller-role.name
}

resource "aws_eks_pod_identity_association" "lb_association" {
  cluster_name    = aws_eks_cluster.demo-dflight-cluster.name
  namespace       = "kube-system"
  service_account = "${var.ProjectName}-cluster-aws-load-balancer-controller-sa"
  role_arn        = aws_iam_role.lb-controller-role.arn
}

resource "aws_iam_policy" "aws_loadbalancer_controller" {
  name   = "${var.ProjectName}-cluster-aws-loadbalancer-controller"
  policy = file("${path.module}/policies/loadbalancer_controller.json")
}