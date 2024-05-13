# node-group

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
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_ec2_instance_type.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_instance_type) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | (선택) 퍼블릭 IP 주소를 VPC 인스턴스와 연결 여부. Default: `false` | `bool` | `false` | no |
| <a name="input_bootstrap_extra_args"></a> [bootstrap\_extra\_args](#input\_bootstrap\_extra\_args) | (선택) `/etc/eks/bootstrap.sh`에 추가 목록. | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (필수) EKS cluster 이름. | `string` | n/a | yes |
| <a name="input_cni_custom_networking_enabled"></a> [cni\_custom\_networking\_enabled](#input\_cni\_custom\_networking\_enabled) | (선택) EKS CNI 사용자 정의 네트워킹 사용 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_cni_eni_prefix_mode_enabled"></a> [cni\_eni\_prefix\_mode\_enabled](#input\_cni\_eni\_prefix\_mode\_enabled) | (선택) EKS CNI의 ENI Prefix Mode 사용 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | (선택) 실행 할 인스턴스 수. | `number` | `null` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | (선택) `true` 인 경우 인스턴스는 EBS 최적화. Default: `false` | `bool` | `false` | no |
| <a name="input_enabled_metrics"></a> [enabled\_metrics](#input\_enabled\_metrics) | (선택) metirc 값 측정 항목. 가능한 값 GroupDesiredCapacity, GroupInServiceCapacity, GroupPendingCapacity, GroupMinSize, GroupMaxSize, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupStandbyCapacity, GroupTerminatingCapacity, GroupTerminatingInstances, GroupTotalCapacity, GroupTotalInstances. | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingCapacity",<br>  "GroupPendingInstances",<br>  "GroupStandbyCapacity",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingCapacity",<br>  "GroupTerminatingInstances",<br>  "GroupTotalCapacity",<br>  "GroupTotalInstances"<br>]</pre> | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | (선택) 모든 인스턴스가 종료될 때까지 기다리지 않고 Auto Scaling 그룹을 삭제 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | (필수) 인스턴스 AMI. | `string` | n/a | yes |
| <a name="input_instance_key"></a> [instance\_key](#input\_instance\_key) | (필수) 인스턴스에 접속할 key 이름. | `string` | n/a | yes |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | (필수) IAM 인스턴스 profile 이름. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | (필수) 인스턴스 유형. | `string` | n/a | yes |
| <a name="input_kubelet_extra_args"></a> [kubelet\_extra\_args](#input\_kubelet\_extra\_args) | (선택) kubelet 추가 목록. | `list(string)` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | (필수) 최대 인스턴스 수. | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | (필수) 최소 인스턴스 수. | `number` | n/a | yes |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | (선택) 인스턴스 세부 모니터링 활성화 여부. Default: `false` | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (필수) node group 이름. | `string` | n/a | yes |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | (선택) EKS 클러스터 노드 그룹에 추가할 label 맵. | `map(string)` | `{}` | no |
| <a name="input_node_taints"></a> [node\_taints](#input\_node\_taints) | (선택) EKS 클러스터 노드 그룹에 추가할 taint 목록. | `list(string)` | `[]` | no |
| <a name="input_root_volume_encryption_enabled"></a> [root\_volume\_encryption\_enabled](#input\_root\_volume\_encryption\_enabled) | (선택) EBS 암호화 활성화 여부. Default: `false` | `bool` | `false` | no |
| <a name="input_root_volume_encryption_kms_key_id"></a> [root\_volume\_encryption\_kms\_key\_id](#input\_root\_volume\_encryption\_kms\_key\_id) | (선택) `root_volume_encryption_enabled` 이 `true` 일시 설정 가능 하며, 암호화 할 KMS ARN 값 설정. | `string` | `null` | no |
| <a name="input_root_volume_iops"></a> [root\_volume\_iops](#input\_root\_volume\_iops) | (선택) root volume iops. | `number` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | (선택) root volume 사이즈. Default: `20` | `number` | `20` | no |
| <a name="input_root_volume_throughput"></a> [root\_volume\_throughput](#input\_root\_volume\_throughput) | (선택) `root_volume_type` 이 `gp3` 일 경우 처리량 MiB/s. 최대값 1,000 MiB/s. | `number` | `null` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | (선택) root volume 타입. `gp2`, `gp3`, `io1`, `io2`, `sc1`, `st1`. Default: `gp3` | `string` | `"gp3"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (선택) Node Group 에 연결할 추가 보안 그룹 ID 목록. | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (필수) node group 을 생성한 subnets. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (선택) 리소스 태그 내용. | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | (선택) alb or nlb 와 같이 사용하기 위한 target group ARNs. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | ASG(Auto-Scaling Group) ARN. |
| <a name="output_asg_id"></a> [asg\_id](#output\_asg\_id) | ASG(Auto-Scaling Group) ID. |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | ASG(Auto-Scaling Group) 이름. |
| <a name="output_desired_size"></a> [desired\_size](#output\_desired\_size) | EKS cluster node group 실행 할 인스턴스 수. |
| <a name="output_instance_ami"></a> [instance\_ami](#output\_instance\_ami) | EKS cluster node group AMI. |
| <a name="output_instance_key"></a> [instance\_key](#output\_instance\_key) | EKS cluster node group SSH Key 이름. |
| <a name="output_instance_profile"></a> [instance\_profile](#output\_instance\_profile) | EKS cluster node group 에 IAM 인스턴스 profile 이름. |
| <a name="output_instance_type"></a> [instance\_type](#output\_instance\_type) | EKS cluster node group 인스턴스 type. |
| <a name="output_max_size"></a> [max\_size](#output\_max\_size) | EKS cluster node group 최대 인스턴스 수. |
| <a name="output_min_size"></a> [min\_size](#output\_min\_size) | EKS cluster node group 최소 인스턴스 수.. |
| <a name="output_name"></a> [name](#output\_name) | node group 이름. |
| <a name="output_security_groups"></a> [security\_groups](#output\_security\_groups) | Node Group 에 연결할 추가 보안 그룹 ID 목록. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
