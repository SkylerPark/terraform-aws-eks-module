# addon

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
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon_version.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_addon_version.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addon_version"></a> [addon\_version](#input\_addon\_version) | (선택) EKS addon version. | `string` | `null` | no |
| <a name="input_addon_version_type"></a> [addon\_version\_type](#input\_addon\_version\_type) | (필수) EKS addon version type. 가능한 값 `custom`, `default`, `latest`. `custom` 시 `addon_version` 을 입력. Default: `latest` | `string` | `"latest"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (필수) EKS cluster 이름. | `string` | n/a | yes |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | (선택) addon 에 대한 설정값. JSON 문자열 값은 `describe-addon-configuration` 의 결과에 JSON 값과 일치. | `string` | `null` | no |
| <a name="input_conflict_resolution_strategy_on_create"></a> [conflict\_resolution\_strategy\_on\_create](#input\_conflict\_resolution\_strategy\_on\_create) | (Optional) 자체 관리형 추가 기능을 EKS 추가 기능으로 마이그레이션시 충돌을 해결하는 방법. 가능한 값 `NONE`, `OVERWRITE`. Default: `OVERWRITE`.<br>    `NONE` - 추가 기능이 충돌날 경우 값을 변경하지 않음 추가 기능 생성에 실패 가능성이 있음.<br>    `OVERWRITE` - 기본값과 기존값이 다를경우 기본값으로 변경. | `string` | `"OVERWRITE"` | no |
| <a name="input_conflict_resolution_strategy_on_update"></a> [conflict\_resolution\_strategy\_on\_update](#input\_conflict\_resolution\_strategy\_on\_update) | (선택) EKS 기본값에서 값을 변경하는 경우 추가기능에 대한 충돌을 해결하는 방법. 가능한 값 `NONE`, `OVERWRITE` and `PRESERVE`. Default: `OVERWRITE`.<br>    `NONE` - 추가 기능이 충돌날 경우 값을 변경하지 않음.<br>    `OVERWRITE` - 기본값과 기존값이 다를경우 기본값으로 변경.<br>    `PRESERVE` - Amazon EKS는 값을 보존. | `string` | `"OVERWRITE"` | no |
| <a name="input_name"></a> [name](#input\_name) | (필수) EKS addon 이름. | `string` | n/a | yes |
| <a name="input_preserve_on_delete"></a> [preserve\_on\_delete](#input\_preserve\_on\_delete) | (선택) EKS 추가 기능을 삭제할 때 생성된 Kubernetes 리소스를 클러스터에 유지할지 여부. Default: `false` | `bool` | `false` | no |
| <a name="input_service_account_role"></a> [service\_account\_role](#input\_service\_account\_role) | (선택) addon 에 서비스 계정 IAM role ARN. addon 에 역할이 없을경우 노드의 IAM 역할로 권한을 사용. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (선택) 리소스 태그 내용. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (선택) 리소스 생성/업데이트/삭제될 때까지 기다리는 시간. | <pre>object({<br>    create = optional(string, "20m")<br>    update = optional(string, "20m")<br>    delete = optional(string, "40m")<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | EKS addon ARN. |
| <a name="output_conflict_resolution_strategy_on_create"></a> [conflict\_resolution\_strategy\_on\_create](#output\_conflict\_resolution\_strategy\_on\_create) | 자체 관리형 추가 기능을 EKS 추가 기능으로 마이그레이션시 충돌을 해결하는 방법. |
| <a name="output_conflict_resolution_strategy_on_update"></a> [conflict\_resolution\_strategy\_on\_update](#output\_conflict\_resolution\_strategy\_on\_update) | EKS 기본값에서 값을 변경하는 경우 추가기능에 대한 충돌을 해결하는 방법. |
| <a name="output_default_version"></a> [default\_version](#output\_default\_version) | EKS cluster version 에 대한 default version 정보. |
| <a name="output_id"></a> [id](#output\_id) | EKS addon ID. |
| <a name="output_latest_version"></a> [latest\_version](#output\_latest\_version) | EKS cluster version 에 대한 latest version 정보. |
| <a name="output_name"></a> [name](#output\_name) | EKS addon 이름. |
| <a name="output_service_account_role"></a> [service\_account\_role](#output\_service\_account\_role) | EKS addon 에 대한 IAM Role ARN |
| <a name="output_version"></a> [version](#output\_version) | EKS addon 이 생성된 version 정보. |
| <a name="output_version_type"></a> [version\_type](#output\_version\_type) | EKS addon 에 version type. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
