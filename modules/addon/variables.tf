variable "cluster_name" {
  description = "(필수) EKS cluster 이름."
  type        = string
  nullable    = false
}

variable "cluster_version" {
  description = "(필수) EKS cluster version."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(필수) EKS addon 이름."
  type        = string
  nullable    = false
}

variable "addon_version_type" {
  description = "(필수) EKS addon version type. 가능한 값 `custom`, `default`, `latest`. `custom` 시 `addon_version` 을 입력. Default: `latest`"
  type        = string
  default     = "latest"
  nullable    = false
}

variable "addon_version" {
  description = "(선택) EKS addon version."
  type        = string
  default     = null
  nullable    = true
}

variable "configuration" {
  description = "(선택) addon 에 대한 설정값. JSON 문자열 값은 `describe-addon-configuration` 의 결과에 JSON 값과 일치."
  type        = string
  default     = null
  nullable    = true
}

variable "service_account_role" {
  description = "(선택) addon 에 서비스 계정 IAM role ARN. addon 에 역할이 없을경우 노드의 IAM 역할로 권한을 사용."
  type        = string
  default     = null
  nullable    = true
}

variable "conflict_resolution_strategy_on_create" {
  description = <<EOF
  (Optional) 자체 관리형 추가 기능을 EKS 추가 기능으로 마이그레이션시 충돌을 해결하는 방법. 가능한 값 `NONE`, `OVERWRITE`. Default: `OVERWRITE`.
    `NONE` - 추가 기능이 충돌날 경우 값을 변경하지 않음 추가 기능 생성에 실패 가능성이 있음.
    `OVERWRITE` - 기본값과 기존값이 다를경우 기본값으로 변경.
  EOF
  type        = string
  default     = "OVERWRITE"
  nullable    = false

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.conflict_resolution_strategy_on_create)
    error_message = "`conflict_resolution_strategy_on_create` 는 다음 값을 설정 해야합니다. `NONE`, `OVERWRITE`."
  }
}

variable "conflict_resolution_strategy_on_update" {
  description = <<EOF
  (선택) EKS 기본값에서 값을 변경하는 경우 추가기능에 대한 충돌을 해결하는 방법. 가능한 값 `NONE`, `OVERWRITE` and `PRESERVE`. Default: `OVERWRITE`.
    `NONE` - 추가 기능이 충돌날 경우 값을 변경하지 않음.
    `OVERWRITE` - 기본값과 기존값이 다를경우 기본값으로 변경.
    `PRESERVE` - Amazon EKS는 값을 보존.

  EOF
  type        = string
  default     = "OVERWRITE"
  nullable    = false

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.conflict_resolution_strategy_on_update)
    error_message = "`conflict_resolution_strategy_on_update` 는 다음 값을 설정 해야합니다. `NONE`, `OVERWRITE`, `PRESERVE`."
  }
}

variable "preserve_on_delete" {
  description = "(선택) EKS 추가 기능을 삭제할 때 생성된 Kubernetes 리소스를 클러스터에 유지할지 여부. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "timeouts" {
  description = "(선택) 리소스 생성/업데이트/삭제될 때까지 기다리는 시간."
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "40m")
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
