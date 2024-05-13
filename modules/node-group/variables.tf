variable "name" {
  description = "(필수) node group 이름."
  type        = string
  nullable    = false
}

variable "cluster_name" {
  description = "(필수) EKS cluster 이름."
  type        = string
  nullable    = false
}

###################################################
# Auto Scaling Group
###################################################
variable "min_size" {
  description = "(필수) 최소 인스턴스 수."
  type        = number
  nullable    = false
}

variable "max_size" {
  description = "(필수) 최대 인스턴스 수."
  type        = number
  nullable    = false
}

variable "desired_size" {
  description = "(선택) 실행 할 인스턴스 수."
  type        = number
  default     = null
  nullable    = true
}

variable "subnets" {
  description = "(필수) node group 을 생성한 subnets."
  type        = list(string)
  nullable    = false
}

variable "target_group_arns" {
  description = "(선택) alb or nlb 와 같이 사용하기 위한 target group ARNs."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "force_delete" {
  description = "(선택) 모든 인스턴스가 종료될 때까지 기다리지 않고 Auto Scaling 그룹을 삭제 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "enabled_metrics" {
  description = "(선택) metirc 값 측정 항목. 가능한 값 GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances."
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
  ]
  nullable = false
}


###################################################
# Launch Template
###################################################
variable "instance_ami" {
  description = "(필수) 인스턴스 AMI."
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "(필수) 인스턴스 유형."
  type        = string
  nullable    = false
}

variable "instance_key" {
  description = "(필수) 인스턴스에 접속할 key 이름."
  type        = string
  nullable    = false
}

variable "instance_profile" {
  description = "(필수) IAM 인스턴스 profile 이름."
  type        = string
  nullable    = false
}

variable "root_volume_type" {
  description = "(선택) root volume 타입. `gp2`, `gp3`, `io1`, `io2`, `sc1`, `st1`. Default: `gp3`"
  type        = string
  default     = "gp3"
  nullable    = false
}

variable "root_volume_size" {
  description = "(선택) root volume 사이즈. Default: `20`"
  type        = number
  default     = 20
  nullable    = false
}

variable "root_volume_iops" {
  description = "(선택) root volume iops."
  type        = number
  default     = null
}

variable "root_volume_throughput" {
  description = "(선택) `root_volume_type` 이 `gp3` 일 경우 처리량 MiB/s. 최대값 1,000 MiB/s."
  type        = number
  default     = null
}

variable "root_volume_encryption_enabled" {
  description = "(선택) EBS 암호화 활성화 여부. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "root_volume_encryption_kms_key_id" {
  description = "(선택) `root_volume_encryption_enabled` 이 `true` 일시 설정 가능 하며, 암호화 할 KMS ARN 값 설정."
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "(선택) `true` 인 경우 인스턴스는 EBS 최적화. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "security_groups" {
  description = "(선택) Node Group 에 연결할 추가 보안 그룹 ID 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "associate_public_ip_address" {
  description = "(선택) 퍼블릭 IP 주소를 VPC 인스턴스와 연결 여부. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "monitoring_enabled" {
  description = "(선택) 인스턴스 세부 모니터링 활성화 여부. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "node_labels" {
  description = "(선택) EKS 클러스터 노드 그룹에 추가할 label 맵."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "node_taints" {
  description = "(선택) EKS 클러스터 노드 그룹에 추가할 taint 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "bootstrap_extra_args" {
  description = "(선택) `/etc/eks/bootstrap.sh`에 추가 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "kubelet_extra_args" {
  description = "(선택) kubelet 추가 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "cni_custom_networking_enabled" {
  description = "(선택) EKS CNI 사용자 정의 네트워킹 사용 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "cni_eni_prefix_mode_enabled" {
  description = "(선택) EKS CNI의 ENI Prefix Mode 사용 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "(선택) 리소스 태그 내용."
  type        = map(string)
  default     = {}
  nullable    = false
}
