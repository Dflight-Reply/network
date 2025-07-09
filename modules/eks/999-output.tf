output "eks" {
  value = aws_eks_cluster.demo-dflight-cluster
}

output "eks-node-group" {
  value = aws_eks_node_group.demo-dflight-node-group
}

output "launch_template" {
  value = aws_launch_template.demo-dflight-eks-node
}