output "id" {
  description = "EKS addon ID."
  value       = aws_eks_addon.this.id
}

output "arn" {
  description = "EKS addon ARN."
  value       = aws_eks_addon.this.arn
}

output "name" {
  description = "EKS addon 이름."
  value       = aws_eks_addon.this.addon_name
}

output "version" {
  description = "EKS addon 이 생성된 version 정보."
  value       = aws_eks_addon.this.addon_version
}

output "default_version" {
  description = "EKS cluster version 에 대한 default version 정보."
  value       = data.aws_eks_addon_version.default.version
}

output "latest_version" {
  description = "EKS cluster version 에 대한 latest version 정보."
  value       = data.aws_eks_addon_version.latest.version
}

output "version_type" {
  description = "EKS addon 에 version type."
  value       = var.addon_version_type
}

output "service_account_role" {
  description = "EKS addon 에 대한 IAM Role ARN"
  value       = aws_eks_addon.this.service_account_role_arn
}

output "conflict_resolution_strategy_on_create" {
  description = "자체 관리형 추가 기능을 EKS 추가 기능으로 마이그레이션시 충돌을 해결하는 방법."
  value       = aws_eks_addon.this.resolve_conflicts_on_create
}

output "conflict_resolution_strategy_on_update" {
  description = "EKS 기본값에서 값을 변경하는 경우 추가기능에 대한 충돌을 해결하는 방법."
  value       = aws_eks_addon.this.resolve_conflicts_on_update
}

