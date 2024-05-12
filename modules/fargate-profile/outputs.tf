output "name" {
  description = "Fargate Profile 이름."
  value       = aws_eks_fargate_profile.this.fargate_profile_name
}

output "id" {
  description = "Fargate Profile ID."
  value       = aws_eks_fargate_profile.this.id
}

output "arn" {
  description = "Fargate Profile ARN."
  value       = aws_eks_fargate_profile.this.arn
}

output "status" {
  description = "Fargate Profile 상태."
  value       = aws_eks_fargate_profile.this.status
}

output "subnets" {
  description = "Pod 서브넷 ID."
  value       = aws_eks_fargate_profile.this.subnet_ids
}

output "pod_execution_role" {
  description = "EKS Fargate Profile IAM Role ARN."
  value       = aws_eks_fargate_profile.this.pod_execution_role_arn
}

output "selectors" {
  description = "Fargate profile 생성에 필요한 selector 목록."
  value       = aws_eks_fargate_profile.this.selector
}
