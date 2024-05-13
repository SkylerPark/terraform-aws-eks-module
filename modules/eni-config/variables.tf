variable "name" {
  description = "(필수) ENI config 이름. 기본적으로 subnet 이름으로 생성 하는게 좋음."
  type        = string
  nullable    = false
}

variable "security_groups" {
  description = "(필수) ENI Config 가 생성 시 사용되는 Security Group 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "subnet" {
  description = "(필수) ENI 가 생성 될 subnet ID."
  type        = string
  nullable    = false
}
