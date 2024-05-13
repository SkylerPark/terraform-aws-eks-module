# cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.cluster_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_identity_provider_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) | resource |
| [aws_vpc_security_group_egress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint_access"></a> [endpoint\_access](#input\_endpoint\_access) | (선택) Kubernetes API 서버 엔드포인트 액세스 구성. `endpoint_access` 블록 내용.<br>    (선택) `private_access_enabled` - 클러스터의 Kubernetes API 서버 엔드포인트에 대한 private 액세스를 활성화할지 여부. Default: `true`.<br>    (선택) `public_access_enabled` - 클러스터의 Kubernetes API 서버 엔드포인트에 대한 public 액세스를 활성화할지 여부. Default: `false`<br>    (선택) `public_access_cidrs` - 클러스터의 kubernetes API 서버 엔드포인트에 대한 public 통신하도록 허용된 CIDR 목록. Default: `0.0.0.0/0` . | <pre>object({<br>    private_access_enabled = optional(bool, true)<br>    public_access_enabled  = optional(bool, false)<br>    public_access_cidrs    = optional(list(string), ["0.0.0.0/0"])<br>  })</pre> | `{}` | no |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | (선택) EKS 클러스터 IAM 역할의 ARN. | `string` | `null` | no |
| <a name="input_kubernetes_network_config"></a> [kubernetes\_network\_config](#input\_kubernetes\_network\_config) | (선택) Kubernetes 네트워크 설정. `kubernetes_network_config` 블록 내용.<br>    (선택) `service_ipv4_cidr` - Kubernetes Pod 및 서비스 IP 주소를 할당할 CIDR 블록. 블록을 지정하지 않으면 Kubernetes는 '10.100.0.0/16' 또는 '172.20.0.0/16' CIDR 블록의 주소를 할당.<br>    (선택) `ip_family` - Kubernetes Pod 및 서비스 주소를 할당하는 데 사용되는 IP 제품. 유효한 값 'IPV4', 'IPV6'. Default: `IPV4`. | <pre>object({<br>    service_ipv4_cidr = optional(string)<br>    ip_family         = optional(string, "IPV4")<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (선택) EKS 클러스터에 사용할 원하는 Kubernetes 버전. Default: `1.29`. | `string` | `"1.29"` | no |
| <a name="input_log_types"></a> [log\_types](#input\_log\_types) | (선택) 활성화 할 control plane 로깅 세트. | `set(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | (필수) EKS 클러스터의 이름. M영숫자 문자로 시작해야 하며 영숫자 문자, 대시, 밑줄만 포함 길이는 1-100자 사이. | `string` | n/a | yes |
| <a name="input_oidc_identity_providers"></a> [oidc\_identity\_providers](#input\_oidc\_identity\_providers) | (선택) Kubernetes 클러스터에 대한 사용자 인증을 위한 추가 방법으로 연결할 OIDC ID 공급자 목록. `oidc_identity_providers` 블록 내용.<br>    (필수) `name` - ID 공급자 구성의 고유한 이름.<br>    (필수) `issuer_url` - OIDC Identity Provider issuer URL.<br>    (필수) `client_id` - OIDC Identity Provider client ID.<br>    (선택) `required_claims` - ID 토큰의 필수 클레임을 설명하는 키 값 쌍.<br>    (선택) `username_claim` - 공급자가 사용자 이름으로 사용할 JWT 클레임.<br>    (선택) `username_prefix` - 사용자 이름 클레임 앞에 추가되는 접두사.<br>    (선택) `groups_claim` - 공급자가 그룹을 반환하는 데 사용할 JWT 클레임.<br>    (선택) `groups_prefix` - 그룹 클레임 앞에 추가되는 접두사(예: `oidc:`). | <pre>list(object({<br>    name       = string<br>    issuer_url = string<br>    client_id  = string<br><br>    required_claims = optional(map(string), {})<br>    username_claim  = optional(string)<br>    username_prefix = optional(string)<br>    groups_claim    = optional(string)<br>    groups_prefix   = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_outpost_config"></a> [outpost\_config](#input\_outpost\_config) | (선택) EKS 클러스터 outpost 구성. `outpost_config` 블록 내용.<br>    (선택) `outposts` - outpost ARN 목록.<br>    (선택) `control_plane_instance_type` - outpost 에서 사용할 EC2 인스턴스 유형.<br>      - 1–20개의 노드의 경우, large instance type 을 지정하는 게 좋음.<br>      - 21–100개의 노드의 경우, xlarge instance type 을 지정하는 게 좋음..<br>      - 101–250개의 노드의 경우, 2xlarge instance type 을 지정하는 게 좋음.<br>    (선택) `control_plane_placement_group` - Kubernetes control plane instances 배치 그룹 이름. | <pre>object({<br>    outposts                      = list(string)<br>    control_plane_instance_type   = string<br>    control_plane_placement_group = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_secrets_encryption"></a> [secrets\_encryption](#input\_secrets\_encryption) | (선택) Kubernetes 암호화 구성. `secrets_encryption` 블록 내용.<br>    (선택) `enabled` - Kubernetes 암호화 활성화 여부. Default: `false`.<br>    (선택) `kms_key` - Kubernetes 암호화에 사용할 AWS KMS 키 ID. | <pre>object({<br>    enabled = optional(bool, false)<br>    kms_key = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | (선택) 송신 규칙 설정. `ingress_rules` 블록 내용.<br>    (Required) `id` - 송신에 대한 규칙 ID 값 Terraform 코드에서만 사용.<br>    (Optional) `description` - 규칙에 대한 설명.<br>    (Required) `protocol` - 규칙에 대한 프로토콜. `protocol` 이 `-1` 로 설정시 모든 프로토콜 모든 포트범위로 되며, `from_port` 와 `to_port` 값은 정의 불가.<br>    (Required) `from_port` - 포트 범위의 시작. TCP and UDP protocols, or an ICMP/ICMPv6 type.<br>    (Required) `to_port` - 포트 범위의 끝. TCP and UDP protocols, or an ICMP/ICMPv6 code.<br>    (Optional) `ipv4_cidrs` - IPv4 에 대한 CIDR 리스트.<br>    (Optional) `ipv6_cidrs` - IPv6 에 대한 CIDR 리스트.<br>    (Optional) `prefix_lists` - prefix ID 리스트.<br>    (Optional) `security_groups` - security group ID 리스트.<br>    (Optional) `self` - self 보안 그룹으로 추가할지 여부. | <pre>list(object({<br>    id              = string<br>    description     = optional(string, "")<br>    protocol        = string<br>    from_port       = number<br>    to_port         = number<br>    ipv4_cidrs      = optional(list(string), [])<br>    ipv6_cidrs      = optional(list(string), [])<br>    prefix_lists    = optional(list(string), [])<br>    security_groups = optional(list(string), [])<br>    self            = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | (선택) 수신 규칙 설정. `ingress_rules` 블록 내용.<br>    (Required) `id` - 수신에 대한 규칙 ID 값 Terraform 코드에서만 사용.<br>    (Optional) `description` - 규칙에 대한 설명.<br>    (Required) `protocol` - 규칙에 대한 프로토콜. `protocol` 이 `-1` 로 설정시 모든 프로토콜 모든 포트범위로 되며, `from_port` 와 `to_port` 값은 정의 불가.<br>    (Required) `from_port` - 포트 범위의 시작. TCP and UDP protocols, or an ICMP/ICMPv6 type.<br>    (Required) `to_port` - 포트 범위의 끝. TCP and UDP protocols, or an ICMP/ICMPv6 code.<br>    (Optional) `ipv4_cidrs` - IPv4 에 대한 CIDR 리스트.<br>    (Optional) `ipv6_cidrs` - IPv6 에 대한 CIDR 리스트.<br>    (Optional) `prefix_lists` - prefix ID 리스트.<br>    (Optional) `security_groups` - security group ID 리스트.<br>    (Optional) `self` - self 보안 그룹으로 추가할지 여부. | <pre>list(object({<br>    id              = string<br>    description     = optional(string, "")<br>    protocol        = string<br>    from_port       = number<br>    to_port         = number<br>    ipv4_cidrs      = optional(list(string), [])<br>    ipv6_cidrs      = optional(list(string), [])<br>    prefix_lists    = optional(list(string), [])<br>    security_groups = optional(list(string), [])<br>    self            = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (선택) Kubernetes API 서버 엔드포인트와 연결할 추가 보안 그룹 ID 목록. | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (필수) 서로 다른 가용성 영역 두개 이상의 서브넷 ID 목록. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (선택) 리소스 태그 내용. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (선택) 리소스 생성/업데이트/삭제될 때까지 기다리는 시간. | <pre>object({<br>    create = optional(string, "30m")<br>    update = optional(string, "60m")<br>    delete = optional(string, "15m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | cluster ARN. |
| <a name="output_ca_cert"></a> [ca\_cert](#output\_ca\_cert) | 클러스터와 통신하는 데 필요한 base64로 인코딩된 인증서 데이터. |
| <a name="output_cluster_role"></a> [cluster\_role](#output\_cluster\_role) | EKS cluster IAM Role ARN. |
| <a name="output_cluster_security_group"></a> [cluster\_security\_group](#output\_cluster\_security\_group) | 클러스터에 대해 EKS가 생성한 보안 그룹. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Kubernetes API server Endpoint. |
| <a name="output_endpoint_access"></a> [endpoint\_access](#output\_endpoint\_access) | Kubernetes API 서버 엔드포인트에 대한 액세스 구성. |
| <a name="output_id"></a> [id](#output\_id) | cluster ID. |
| <a name="output_kubernetes_network_config"></a> [kubernetes\_network\_config](#output\_kubernetes\_network\_config) | Kubernetes network 설정 정보.<br>    `service_ipv4_cidr` - Kubernetes 서비스 IP 주소에 할당된 IPv4 CIDR 블록.<br>    `service_ipv6_cidr` - Kubernetes 서비스 IP 주소에 할당된 IPv6 CIDR 블록.<br>    `ip_family` - Kubernetes Pod 및 서비스 주소를 할당하는 데 사용되는 IP 제품군. |
| <a name="output_logging"></a> [logging](#output\_logging) | control plane logging 설정 정보. |
| <a name="output_name"></a> [name](#output\_name) | cluster 이름. |
| <a name="output_oidc_identity_providers"></a> [oidc\_identity\_providers](#output\_oidc\_identity\_providers) | 클러스터에 연결된 모든 OIDC ID 공급자의 맵. |
| <a name="output_outpost_config"></a> [outpost\_config](#output\_outpost\_config) | EKS cluste outpost 정보r.<br>    `outposts` - Outposts ARN 리스트.<br>    `control_plane_instance_type` - Outposts EC2 인스턴스 타입.<br>    `control_plane_placement_group` - Outposts placement group 이름. |
| <a name="output_platform_version"></a> [platform\_version](#output\_platform\_version) | cluster platform version. |
| <a name="output_secrets_encryption"></a> [secrets\_encryption](#output\_secrets\_encryption) | Kubernetes 암호화 구성 정보. |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | EKS control plane 추가 보안 그룹 리스트. |
| <a name="output_status"></a> [status](#output\_status) | EKS cluster 상태. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | cluster control plane 이 위치한 subnet ID. |
| <a name="output_version"></a> [version](#output\_version) | cluster Kubernetes server version. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | cluster 가 생성된 VPC ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
