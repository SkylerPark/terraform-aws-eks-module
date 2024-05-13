# eni-config

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.this](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (필수) ENI config 이름. 기본적으로 subnet 이름으로 생성 하는게 좋음. | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (필수) ENI Config 가 생성 시 사용되는 Security Group 목록. | `list(string)` | `[]` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | (필수) ENI 가 생성 될 subnet ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eni_config"></a> [eni\_config](#output\_eni\_config) | eni config yaml 내용 |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
