# aws-auth

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fargate_profile_roles"></a> [fargate\_profile\_roles](#input\_fargate\_profile\_roles) | (선택) EKS fargate profiles 에 대한 AWS IAM role ARN 목록. | `list(string)` | `[]` | no |
| <a name="input_map_accounts"></a> [map\_accounts](#input\_map\_accounts) | (선택) AWS account numbers 에 대한 목록. | `list(string)` | `[]` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | (선택) IAM roles 및 Kubernetes RBAC 에 대한 추가 매핑 목록. | <pre>list(object({<br>    iam_role = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | (선택) IAM users 및 Kubernetes RBAC 에 대한 추가 매핑 목록. | <pre>list(object({<br>    iam_user = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_node_roles"></a> [node\_roles](#input\_node\_roles) | (선택) EKS 노드에 대한 AWS IAM role ARN 목록. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_map"></a> [config\_map](#output\_config\_map) | `kube-system/aws-auth` ConfigMap 정보. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
