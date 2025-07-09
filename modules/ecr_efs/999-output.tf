output "ecr" {
  value = aws_ecr_repository.ecr-dflight
}

output "efs" {
  value = aws_efs_file_system.dflight-efs
}