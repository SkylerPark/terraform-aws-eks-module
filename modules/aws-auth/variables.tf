variable "node_roles" {
  description = "(선택) EKS 노드에 대한 AWS IAM role ARN 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "fargate_profile_roles" {
  description = "(선택) EKS fargate profiles 에 대한 AWS IAM role ARN 목록."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "map_roles" {
  description = "(선택) IAM roles 및 Kubernetes RBAC 에 대한 추가 매핑 목록."
  type = list(object({
    iam_role = string
    username = string
    groups   = list(string)
  }))
  default  = []
  nullable = false
}

variable "map_users" {
  description = "(선택) IAM users 및 Kubernetes RBAC 에 대한 추가 매핑 목록."
  type = list(object({
    iam_user = string
    username = string
    groups   = list(string)
  }))
  default  = []
  nullable = false
}

variable "map_accounts" {
  description = "(선택) AWS account numbers 에 대한 목록."
  type        = list(string)
  default     = []
  nullable    = false
}
