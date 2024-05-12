variable "cluster_name" {
  description = "(필수) Fargate Profile 을 생성 할 EKS Cluster 이름."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(필수) Fargate Profile 이름."
  type        = string
  nullable    = false
}

variable "subnets" {
  description = "(Required) The IDs of subnets to launch your pods into. At this time, pods running on Fargate are not assigned public IP addresses, so only private subnets (with no direct route to an Internet Gateway) are accepted"
  type        = list(string)
  nullable    = false
}

variable "default_pod_execution_role" {
  description = <<EOF
  (Optional) A configuration for the default pod execution role to use for pods that match the selectors in the Fargate profile. Use `pod_execution_role` if `default_pod_execution_role.enabled` is `false`. `default_pod_execution_role` as defined below.
    (Optional) `enabled` - Whether to create the default pod execution role. Defaults to `true`.
    (Optional) `name` - The name of the default pod execution role. Defaults to `eks-$${var.cluster_name}-fargate-profile-$${var.name}`.
    (Optional) `path` - The path of the default pod execution role. Defaults to `/`.
    (Optional) `description` - The description of the default pod execution role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default pod execution role. `AmazonEKSFargatePodExecutionRolePolicy` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default pod execution role. (`name` => `policy`).
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies        = optional(list(string), [])
    inline_policies = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "iam_role" {
  description = "(선택) EKS Fargate IAM Role ARN."
  type        = string
  default     = null
  nullable    = true
}

variable "selectors" {
  description = <<EOF
  (선택) Fargate profile 생성에 필요한 selector 목록. `selectors` 블록 내용.
    (필수) `namespace` - Kubernetes namespace selection.
    (선택) `labels` - Key-value map 기반 Kubernetes labels selection.
  EOF
  type = list(object({
    namespace = string
    labels    = optional(map(string), {})
  }))
  default  = []
  nullable = false
}

variable "timeouts" {
  description = "(선택) 리소스 생성/업데이트/삭제될 때까지 기다리는 시간."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
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
