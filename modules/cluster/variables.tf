variable "name" {
  description = "(필수) EKS 클러스터의 이름. M영숫자 문자로 시작해야 하며 영숫자 문자, 대시, 밑줄만 포함 길이는 1-100자 사이."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) <= 100
    error_message = "클러스터 이름의 길이는 100자 이내여야 합니다.."
  }
}

variable "kubernetes_version" {
  description = "(선택) EKS 클러스터에 사용할 원하는 Kubernetes 버전. Default: `1.29`."
  type        = string
  default     = "1.29"
  nullable    = false
}

variable "kubernetes_network_config" {
  description = <<EOF
  (선택) Kubernetes 네트워크 설정. `kubernetes_network_config` 블록 내용.
    (선택) `service_ipv4_cidr` - Kubernetes Pod 및 서비스 IP 주소를 할당할 CIDR 블록. 블록을 지정하지 않으면 Kubernetes는 '10.100.0.0/16' 또는 '172.20.0.0/16' CIDR 블록의 주소를 할당.
    (선택) `ip_family` - Kubernetes Pod 및 서비스 주소를 할당하는 데 사용되는 IP 제품. 유효한 값 'IPV4', 'IPV6'. Default: `IPV4`.
  EOF
  type = object({
    service_ipv4_cidr = optional(string)
    ip_family         = optional(string, "IPV4")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["IPV4", "IPV6"], var.kubernetes_network_config.ip_family)
    error_message = "`kubernetes_network_config.ip_family` 값은 `IPV4`, `IPV6` 중에 하나만 선택 가능 합니다."
  }
}

variable "subnets" {
  description = "(필수) 서로 다른 가용성 영역 두개 이상의 서브넷 ID 목록."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.subnets) > 1
    error_message = "두 개 이상의 서로 다른 가용성 영역에 있어야 합니다."
  }
}

variable "security_groups" {
  description = "(선택) Kubernetes API 서버 엔드포인트와 연결할 추가 보안 그룹 ID 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "security_group_ingress_rules" {
  description = <<EOF
  (선택) 수신 규칙 설정. `ingress_rules` 블록 내용.
    (Required) `id` - 수신에 대한 규칙 ID 값 Terraform 코드에서만 사용.
    (Optional) `description` - 규칙에 대한 설명.
    (Required) `protocol` - 규칙에 대한 프로토콜. `protocol` 이 `-1` 로 설정시 모든 프로토콜 모든 포트범위로 되며, `from_port` 와 `to_port` 값은 정의 불가.
    (Required) `from_port` - 포트 범위의 시작. TCP and UDP protocols, or an ICMP/ICMPv6 type.
    (Required) `to_port` - 포트 범위의 끝. TCP and UDP protocols, or an ICMP/ICMPv6 code.
    (Optional) `ipv4_cidrs` - IPv4 에 대한 CIDR 리스트.
    (Optional) `ipv6_cidrs` - IPv6 에 대한 CIDR 리스트.
    (Optional) `prefix_lists` - prefix ID 리스트.
    (Optional) `security_groups` - security group ID 리스트.
    (Optional) `self` - self 보안 그룹으로 추가할지 여부.
  EOF
  type = list(object({
    id              = string
    description     = optional(string, "")
    protocol        = string
    from_port       = number
    to_port         = number
    ipv4_cidrs      = optional(list(string), [])
    ipv6_cidrs      = optional(list(string), [])
    prefix_lists    = optional(list(string), [])
    security_groups = optional(list(string), [])
    self            = optional(bool, false)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.security_group_ingress_rules :
      anytrue([
        length(rule.ipv4_cidrs) > 0,
        length(rule.ipv6_cidrs) > 0,
        length(rule.prefix_lists) > 0,
        length(rule.security_groups) > 0,
        rule.self,
      ])
    ])
    error_message = "`ipv4_cidrs`, `ipv6_cidrs`, `prefix_lists`, `security_groups` or `self` 중 하나 이상을 지정해야 합니다."
  }
}

variable "security_group_egress_rules" {
  description = <<EOF
  (선택) 송신 규칙 설정. `ingress_rules` 블록 내용.
    (Required) `id` - 송신에 대한 규칙 ID 값 Terraform 코드에서만 사용.
    (Optional) `description` - 규칙에 대한 설명.
    (Required) `protocol` - 규칙에 대한 프로토콜. `protocol` 이 `-1` 로 설정시 모든 프로토콜 모든 포트범위로 되며, `from_port` 와 `to_port` 값은 정의 불가.
    (Required) `from_port` - 포트 범위의 시작. TCP and UDP protocols, or an ICMP/ICMPv6 type.
    (Required) `to_port` - 포트 범위의 끝. TCP and UDP protocols, or an ICMP/ICMPv6 code.
    (Optional) `ipv4_cidrs` - IPv4 에 대한 CIDR 리스트.
    (Optional) `ipv6_cidrs` - IPv6 에 대한 CIDR 리스트.
    (Optional) `prefix_lists` - prefix ID 리스트.
    (Optional) `security_groups` - security group ID 리스트.
    (Optional) `self` - self 보안 그룹으로 추가할지 여부.
  EOF
  type = list(object({
    id              = string
    description     = optional(string, "")
    protocol        = string
    from_port       = number
    to_port         = number
    ipv4_cidrs      = optional(list(string), [])
    ipv6_cidrs      = optional(list(string), [])
    prefix_lists    = optional(list(string), [])
    security_groups = optional(list(string), [])
    self            = optional(bool, false)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.security_group_egress_rules :
      anytrue([
        length(rule.ipv4_cidrs) > 0,
        length(rule.ipv6_cidrs) > 0,
        length(rule.prefix_lists) > 0,
        length(rule.security_groups) > 0,
        rule.self,
      ])
    ])
    error_message = "`ipv4_cidrs`, `ipv6_cidrs`, `prefix_lists`, `security_groups` or `self` 중 하나 이상을 지정해야 합니다."
  }
}

variable "endpoint_access" {
  description = <<EOF
  (선택) Kubernetes API 서버 엔드포인트 액세스 구성. `endpoint_access` 블록 내용.
    (선택) `private_access_enabled` - 클러스터의 Kubernetes API 서버 엔드포인트에 대한 private 액세스를 활성화할지 여부. Default: `true`.
    (선택) `public_access_enabled` - 클러스터의 Kubernetes API 서버 엔드포인트에 대한 public 액세스를 활성화할지 여부. Default: `false`
    (선택) `public_access_cidrs` - 클러스터의 kubernetes API 서버 엔드포인트에 대한 public 통신하도록 허용된 CIDR 목록. Default: `0.0.0.0/0` .
  EOF
  type = object({
    private_access_enabled = optional(bool, true)
    public_access_enabled  = optional(bool, false)
    public_access_cidrs    = optional(list(string), ["0.0.0.0/0"])
  })
  default  = {}
  nullable = false
}

variable "iam_role" {
  description = "(선택) EKS 클러스터 IAM 역할의 ARN."
  type        = string
  default     = null
  nullable    = true
}

variable "log_types" {
  description = "(선택) 활성화 할 control plane 로깅 세트."
  type        = set(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  nullable    = false
}

variable "secrets_encryption" {
  description = <<EOF
  (선택) Kubernetes 암호화 구성. `secrets_encryption` 블록 내용.
    (선택) `enabled` - Kubernetes 암호화 활성화 여부. Default: `false`.
    (선택) `kms_key` - Kubernetes 암호화에 사용할 AWS KMS 키 ID.
  EOF
  type = object({
    enabled = optional(bool, false)
    kms_key = optional(string)
  })
  default  = {}
  nullable = false
}

variable "oidc_identity_providers" {
  description = <<EOF
  (선택) Kubernetes 클러스터에 대한 사용자 인증을 위한 추가 방법으로 연결할 OIDC ID 공급자 목록. `oidc_identity_providers` 블록 내용.
    (필수) `name` - ID 공급자 구성의 고유한 이름.
    (필수) `issuer_url` - OIDC Identity Provider issuer URL.
    (필수) `client_id` - OIDC Identity Provider client ID.
    (선택) `required_claims` - ID 토큰의 필수 클레임을 설명하는 키 값 쌍.
    (선택) `username_claim` - 공급자가 사용자 이름으로 사용할 JWT 클레임.
    (선택) `username_prefix` - 사용자 이름 클레임 앞에 추가되는 접두사.
    (선택) `groups_claim` - 공급자가 그룹을 반환하는 데 사용할 JWT 클레임.
    (선택) `groups_prefix` - 그룹 클레임 앞에 추가되는 접두사(예: `oidc:`).
  EOF
  type = list(object({
    name       = string
    issuer_url = string
    client_id  = string

    required_claims = optional(map(string), {})
    username_claim  = optional(string)
    username_prefix = optional(string)
    groups_claim    = optional(string)
    groups_prefix   = optional(string)
  }))
  default  = []
  nullable = false
}

variable "outpost_config" {
  description = <<EOF
  (선택) EKS 클러스터 outpost 구성. `outpost_config` 블록 내용.
    (선택) `outposts` - outpost ARN 목록.
    (선택) `control_plane_instance_type` - outpost 에서 사용할 EC2 인스턴스 유형.
      - 1–20개의 노드의 경우, large instance type 을 지정하는 게 좋음.
      - 21–100개의 노드의 경우, xlarge instance type 을 지정하는 게 좋음..
      - 101–250개의 노드의 경우, 2xlarge instance type 을 지정하는 게 좋음.
    (선택) `control_plane_placement_group` - Kubernetes control plane instances 배치 그룹 이름.
  EOF
  type = object({
    outposts                      = list(string)
    control_plane_instance_type   = string
    control_plane_placement_group = optional(string)
  })
  default  = null
  nullable = true
}

variable "timeouts" {
  description = "(선택) 리소스 생성/업데이트/삭제될 때까지 기다리는 시간."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "60m")
    delete = optional(string, "15m")
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(선택) 리소스 태그 내용."
  type        = map(string)
  default     = {}
  nullable    = false
}
