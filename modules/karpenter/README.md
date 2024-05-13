# karpenter

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
| [kubectl_manifest.aws_node_template](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |
| [kubectl_manifest.provisioner](https://registry.terraform.io/providers/gavinbunney/kubectl/1.14.0/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_node_template"></a> [aws\_node\_template](#input\_aws\_node\_template) | (필수) karpenter aws node template 설정 `aws_node_template` 블록 내용.<br>    (필수) `name` - aws node template 리소스의 이름.<br>    (필수) `subnet_selector` - node 가 생성시 subnet 을 참고하는 key value. (map(string))<br>    (필수) `security_group_selector` - node 가 생성시 security group 을 참고하는 key value.(map(string)).<br>    (필수) `ami_family` - node 생성시 ami family 참고 값.<br>    (필수) `block_device_mappings` - node 생성시 디스크에 대한 설정값 list(any).<br>    (선택) `tags` - node 생성시 tag 설정값 map(string). | <pre>object({<br>    name                    = string<br>    subnet_selector         = map(string)<br>    security_group_selector = map(string)<br>    ami_family              = string<br>    block_device_mappings   = list(any)<br>    tags                    = map(string)<br>  })</pre> | n/a | yes |
| <a name="input_provisioner"></a> [provisioner](#input\_provisioner) | (필수) karpenter provisioner 설정 `provisioner` 블록 내용.<br>    (필수) `name` - provisioner 리소스의 이름.<br>    (필수) `requirements` - karpenter provisioning 할때 인스턴스 설정값의 집합 (list(any)).<br>    (선택) `provider_ref` - provider ref 설정 map(string).<br>    (선택) `consolidation` - karpenter 안정성 및 성능 향상에 대한 옵션 map(string). | <pre>object({<br>    name          = optional(string)<br>    requirements  = optional(list(any), [])<br>    provider_ref  = optional(map(string))<br>    consolidation = optional(map(string))<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_node_template"></a> [aws\_node\_template](#output\_aws\_node\_template) | aws\_node\_template yaml 내용 |
| <a name="output_provisioner"></a> [provisioner](#output\_provisioner) | provisioner yaml 내용 |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
