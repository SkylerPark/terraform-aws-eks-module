# fargate-profile

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
| [aws_eks_fargate_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (필수) Fargate Profile 을 생성 할 EKS Cluster 이름. | `string` | n/a | yes |
| <a name="input_default_pod_execution_role"></a> [default\_pod\_execution\_role](#input\_default\_pod\_execution\_role) | (Optional) A configuration for the default pod execution role to use for pods that match the selectors in the Fargate profile. Use `pod_execution_role` if `default_pod_execution_role.enabled` is `false`. `default_pod_execution_role` as defined below.<br>    (Optional) `enabled` - Whether to create the default pod execution role. Defaults to `true`.<br>    (Optional) `name` - The name of the default pod execution role. Defaults to `eks-${var.cluster_name}-fargate-profile-${var.name}`.<br>    (Optional) `path` - The path of the default pod execution role. Defaults to `/`.<br>    (Optional) `description` - The description of the default pod execution role.<br>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default pod execution role. `AmazonEKSFargatePodExecutionRolePolicy` is always attached. Defaults to `[]`.<br>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default pod execution role. (`name` => `policy`). | <pre>object({<br>    enabled     = optional(bool, true)<br>    name        = optional(string)<br>    path        = optional(string, "/")<br>    description = optional(string, "Managed by Terraform.")<br><br>    policies        = optional(list(string), [])<br>    inline_policies = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | (선택) EKS Fargate IAM Role ARN. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (필수) Fargate Profile 이름. | `string` | n/a | yes |
| <a name="input_selectors"></a> [selectors](#input\_selectors) | (선택) Fargate profile 생성에 필요한 selector 목록. `selectors` 블록 내용.<br>    (필수) `namespace` - Kubernetes namespace selection.<br>    (선택) `labels` - Key-value map 기반 Kubernetes labels selection. | <pre>list(object({<br>    namespace = string<br>    labels    = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) The IDs of subnets to launch your pods into. At this time, pods running on Fargate are not assigned public IP addresses, so only private subnets (with no direct route to an Internet Gateway) are accepted | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (선택) 리소스 태그 내용. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (선택) 리소스 생성/업데이트/삭제될 때까지 기다리는 시간. | <pre>object({<br>    create = optional(string, "10m")<br>    delete = optional(string, "10m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Fargate Profile ARN. |
| <a name="output_id"></a> [id](#output\_id) | Fargate Profile ID. |
| <a name="output_name"></a> [name](#output\_name) | Fargate Profile 이름. |
| <a name="output_pod_execution_role"></a> [pod\_execution\_role](#output\_pod\_execution\_role) | EKS Fargate Profile IAM Role ARN. |
| <a name="output_selectors"></a> [selectors](#output\_selectors) | Fargate profile 생성에 필요한 selector 목록. |
| <a name="output_status"></a> [status](#output\_status) | Fargate Profile 상태. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Pod 서브넷 ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
