resource "aws_eks_cluster" "demo-dflight-cluster" {
  name = "${var.ProjectName}-cluster"

  bootstrap_self_managed_addons = true

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  role_arn = aws_iam_role.demo-cluster-role.arn
  version  = "1.31"

  vpc_config {
    #security_group_ids = []
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true #da modificare entrambi
    endpoint_public_access  = true
  }
  tags = {
    Name               = "${var.ProjectName}-cluster"
    Owner              = var.email
    DateOfDecommission = var.DateOfDecommission
    Schedule           = var.Schedule
  }
  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

}



resource "aws_launch_template" "demo-dflight-eks-node" {
  name_prefix   = "${var.ProjectName}-eks-node-"
#  image_id      = "ami-0c0f6c5b6c16dcae1" aws ssm get-parameter --profile="storm-roma-lab" --name "/aws/service/eks/optimized-ami/1.31/amazon-linux-2/recommended/image_id" --region eu-south-1 --query "Parameter.Value" --output text
   instance_type = "t3.small"

  vpc_security_group_ids = [
    aws_eks_cluster.demo-dflight-cluster.vpc_config[0].cluster_security_group_id,
    var.logic_sg_id
  ]

  tags = {
    Name               = "${var.ProjectName}-node"
    Owner              = var.email
    DateOfDecommission = var.DateOfDecommission
    Schedule           = var.Schedule
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name               = "${var.ProjectName}-node"
      Owner              = var.email
      DateOfDecommission = var.DateOfDecommission
      Schedule           = var.Schedule
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name               = "${var.ProjectName}-volume-node"
      Owner              = var.email
      DateOfDecommission = var.DateOfDecommission
      Schedule           = var.Schedule
    }
  }
}

resource "aws_eks_node_group" "demo-dflight-node-group" {
  cluster_name    = aws_eks_cluster.demo-dflight-cluster.name
  node_group_name = "${var.ProjectName}-node-group2"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.demo-dflight-eks-node.id
    version = aws_launch_template.demo-dflight-eks-node.latest_version
  }
  tags_all = {
    Name               = "${var.ProjectName}-volume-node"
    Owner              = var.email
    DateOfDecommission = var.DateOfDecommission
    Schedule           = var.Schedule
  }

  tags = {
    Name               = "${var.ProjectName}-volume-node"
    Owner              = var.email
    DateOfDecommission = var.DateOfDecommission
    Schedule           = var.Schedule
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_ecr_readonly_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
  ]
}

resource "aws_eks_access_entry" "allow_current" {
  cluster_name  = aws_eks_cluster.demo-dflight-cluster.name
  principal_arn = "arn:aws:iam::523753954008:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_StormRomaLabMembers_79b53c86e5da1a3f"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "current_association" {
  cluster_name  = aws_eks_cluster.demo-dflight-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::523753954008:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_StormRomaLabMembers_79b53c86e5da1a3f"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.allow_current]
}