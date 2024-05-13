variable "name" {
  description = "(필수) Helm release 이름."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(선택) Helm release 설명."
  type        = string
  default     = null
  nullable    = true
}

variable "namespace" {
  description = "(선택) Helm release namespace. Default: `default`"
  type        = string
  default     = "default"
  nullable    = false
}

variable "create_namespace" {
  description = "(선택) Helm release 시 namespace 자동생성 여부. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "chart" {
  description = "(필수) 저장소 내에 설치할 차트 이름"
  type        = string
  nullable    = false
}

variable "chart_version" {
  description = "(선택) 차트 버전. 지정하지 않을시 latest 버전으로 설치."
  type        = string
  default     = null
  nullable    = true
}

variable "repository" {
  description = "(선택) Chart 가 있는 Repository URL."
  type        = string
  nullable    = false
}

variable "values" {
  description = "(선택) Helm 설치기 전달할 값 목록. `-f` 옵션 사용처럼 순서대로 진행."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "timeout" {
  description = "(선택) Helm 설치 까지 기다리는 시간(초). Default: `300`"
  type        = number
  default     = 300
  nullable    = false
}

variable "repository_key_file" {
  description = "(선택) 저장소 인증서 키 파일"
  type        = string
  default     = null
  nullable    = true
}

variable "repository_cert_file" {
  description = "(선택) 저장소 인증서 파일"
  type        = string
  default     = null
  nullable    = true
}

variable "repository_ca_file" {
  description = "(선택) 저장소 인증서 CA 파일"
  type        = string
  default     = null
  nullable    = true
}

variable "repository_username" {
  description = "(선택) repository 로 접근 할 username."
  type        = string
  default     = null
  nullable    = true
}

variable "repository_password" {
  description = "(선택) repository 로 접근 할 password"
  type        = string
  default     = null
  nullable    = true
}

variable "devel" {
  description = "(선택) 차트의 개발버전 사용 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "verify" {
  description = "(선택) Helm 패키지를 설치하기 전 차트의 무결성을 확인 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "keyring" {
  description = "(선택) `verify` 가 `true` 인 경우 확인 에 사용되는 공개키 위치."
  type        = string
  default     = null
  nullable    = true
}

variable "disable_webhooks" {
  description = "(선택) web hook 실행 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "reuse_values" {
  description = "(선택) 업그레이드할때 마지막 release 값을 재사용 및 재정의 할지 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "reset_values" {
  description = "(선택) 업그레이드 할대 chart 에 내장된 값으로 재성정 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "force_update" {
  description = "(선택) 업데이트 강제 삭제/재생성 할성화 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "recreate_pods" {
  description = "(선택) 업그레이드/롤백 중 pod 재시작 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "cleanup_on_fail" {
  description = "(선택) 업그레이드 실패시 업그레이드에 생성된 새 리소스 삭제 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "max_history" {
  description = "(선택) release 당 저장되는 버전 수. Default: `0` (no limit)"
  type        = number
  default     = 0
  nullable    = false
}

variable "atomic" {
  description = "(선택) 설치 프로세스 실패시 차트를 제거 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "skip_crds" {
  description = "(선택) CRD 설치 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "render_subchart_notes" {
  description = "(선택) 설정시 상위차트와 함께 하위 차트 메모를 렌더링. Default: `true`"
  type        = bool
  default     = true
  nullable    = false
}

variable "disable_openapi_validation" {
  description = "(선택) Kubernetes OpenAPI 스키마에 대해 렌더링된 템플릿의 유효성을 검사. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "wait" {
  description = "(선택) 릴리스가 성공으로 표시되기전 모든 리소스가 준비 상태가 될때까지 기다림.  Default: `true`"
  type        = bool
  default     = true
  nullable    = false
}

variable "wait_for_jobs" {
  description = "(선택) `wait` 가 `ture` 인 경우 릴리스가 성공으로 표시되기 전에 모든 작업이 완료될 때까지 기다림. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "dependency_update" {
  description = "(선택) 차트 설치전 종속성 업데이트 실행 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "replace" {
  description = "(선택) 기록에 이름이 남아있는 경우 삭제된 release 인 경우에만 해당이름을 재사용 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "lint" {
  description = "(선택) 실행중 lint 를 실행할지 여부. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "postrender" {
  description = "(선택) helm이 매니페스트 콘텐츠를 변경할 수 있는 매니페스트를 렌더링한 후에 실행할 명령을 구성"
  type        = any
  default     = {}
}

variable "set" {
  description = "(선택) 사용자 정의 값 YAML"
  type        = any
  default     = []
}

variable "set_sensitive" {
  description = "(선택) 계획의 diff에 노출되지 않는 값 yaml과 병합될 사용자 정의 민감한 값"
  type        = any
  default     = []
}
