output "name" {
  description = "cluster 이름."
  value       = aws_eks_cluster.this.name
}

output "id" {
  description = "cluster ID."
  value       = aws_eks_cluster.this.id
}

output "arn" {
  description = "cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "version" {
  description = "cluster Kubernetes server version."
  value       = aws_eks_cluster.this.version
}

output "platform_version" {
  description = "cluster platform version."
  value       = aws_eks_cluster.this.platform_version
}

output "status" {
  description = "EKS cluster 상태."
  value       = aws_eks_cluster.this.status
}

output "kubernetes_network_config" {
  description = <<EOF
  Kubernetes network 설정 정보.
    `service_ipv4_cidr` - Kubernetes 서비스 IP 주소에 할당된 IPv4 CIDR 블록.
    `service_ipv6_cidr` - Kubernetes 서비스 IP 주소에 할당된 IPv6 CIDR 블록.
    `ip_family` - Kubernetes Pod 및 서비스 주소를 할당하는 데 사용되는 IP 제품군.
  EOF
  value = {
    service_ipv4_cidr = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr
    service_ipv6_cidr = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv6_cidr
    ip_family         = upper(aws_eks_cluster.this.kubernetes_network_config[0].ip_family)
  }
}

output "vpc_id" {
  description = "cluster 가 생성된 VPC ID."
  value       = aws_eks_cluster.this.vpc_config[0].vpc_id
}

output "subnets" {
  description = "cluster control plane 이 위치한 subnet ID."
  value       = aws_eks_cluster.this.vpc_config[0].subnet_ids
}

output "cluster_security_group" {
  description = "클러스터에 대해 EKS가 생성한 보안 그룹."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "security_groups" {
  description = "EKS control plane 추가 보안 그룹 리스트."
  value       = aws_eks_cluster.this.vpc_config[0].security_group_ids
}

output "endpoint" {
  description = "Kubernetes API server Endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "endpoint_access" {
  description = "Kubernetes API 서버 엔드포인트에 대한 액세스 구성."
  value = {
    private_access_enabled = aws_eks_cluster.this.vpc_config[0].endpoint_private_access
    public_access_enabled  = aws_eks_cluster.this.vpc_config[0].endpoint_public_access
    public_access_cidrs    = aws_eks_cluster.this.vpc_config[0].public_access_cidrs
  }
}

output "ca_cert" {
  description = "클러스터와 통신하는 데 필요한 base64로 인코딩된 인증서 데이터."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "secrets_encryption" {
  description = "Kubernetes 암호화 구성 정보."
  value = {
    enabled = var.secrets_encryption.enabled
    kms_key = one(aws_eks_cluster.this.encryption_config[*].provider[0].key_arn)
  }
}

output "cluster_role" {
  description = "EKS cluster IAM Role ARN."
  value       = aws_eks_cluster.this.role_arn
}

output "logging" {
  description = "control plane logging 설정 정보."
  value = {
    type = aws_eks_cluster.this.enabled_cluster_log_types
    cloudwatch_log_group = {
      arn  = data.aws_cloudwatch_log_group.this.arn
      name = data.aws_cloudwatch_log_group.this.name
    }
  }
}

output "oidc_identity_providers" {
  description = "클러스터에 연결된 모든 OIDC ID 공급자의 맵."
  value = {
    for name, provider in aws_eks_identity_provider_config.this :
    name => {
      arn        = provider.arn
      status     = provider.status
      name       = provider.oidc[0].identity_provider_config_name
      issuer_url = provider.oidc[0].issuer_url

      required_claims = provider.oidc[0].required_claims
      username_claim  = provider.oidc[0].username_claim
      username_prefix = provider.oidc[0].username_prefix
      groups_claim    = provider.oidc[0].groups_claim
      groups_prefix   = provider.oidc[0].groups_prefix
    }
  }
}

output "outpost_config" {
  description = <<EOF
  EKS cluste outpost 정보r.
    `outposts` - Outposts ARN 리스트.
    `control_plane_instance_type` - Outposts EC2 인스턴스 타입.
    `control_plane_placement_group` - Outposts placement group 이름.
  EOF
  value = (var.outpost_config != null
    ? {
      outposts                      = aws_eks_cluster.this.outpost_config[0].outpost_arns
      cluster_id                    = aws_eks_cluster.this.cluster_id
      control_plane_instance_type   = aws_eks_cluster.this.outpost_config[0].control_plane_instance_type
      control_plane_placement_group = one(aws_eks_cluster.this.outpost_config[0].control_plane_placement[*].group_name)
    }
    : null
  )
}
