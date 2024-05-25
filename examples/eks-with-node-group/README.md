# eks-with-node-group

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_addon"></a> [addon](#module\_addon) | ../../modules/addon | n/a |
| <a name="module_aws_auth"></a> [aws\_auth](#module\_aws\_auth) | ../../modules/aws-auth | n/a |
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ../../modules/cluster | n/a |
| <a name="module_cluster_kms"></a> [cluster\_kms](#module\_cluster\_kms) | git::https://github.com/SkylerPark/terraform-aws-kms-module.git//modules/key/ | tags/1.0.2 |
| <a name="module_cluster_role"></a> [cluster\_role](#module\_cluster\_role) | git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/ | tags/1.0.1 |
| <a name="module_control_plane_sg"></a> [control\_plane\_sg](#module\_control\_plane\_sg) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/ | tags/1.1.5 |
| <a name="module_eip"></a> [eip](#module\_eip) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/elastic-ip/ | tags/1.1.3 |
| <a name="module_helm_releases"></a> [helm\_releases](#module\_helm\_releases) | ../../modules/helm-release | n/a |
| <a name="module_load_balancer_controller_role"></a> [load\_balancer\_controller\_role](#module\_load\_balancer\_controller\_role) | git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/ | tags/1.0.1 |
| <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/nat-gateway/ | tags/1.1.3 |
| <a name="module_node_group"></a> [node\_group](#module\_node\_group) | ../../modules/node-group | n/a |
| <a name="module_node_group_role"></a> [node\_group\_role](#module\_node\_group\_role) | git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/ | tags/1.0.1 |
| <a name="module_node_sg"></a> [node\_sg](#module\_node\_sg) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/ | tags/1.1.5 |
| <a name="module_oidc_provider"></a> [oidc\_provider](#module\_oidc\_provider) | git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-oidc-identity-provider/ | tags/1.0.1 |
| <a name="module_pod_sg"></a> [pod\_sg](#module\_pod\_sg) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/ | tags/1.1.5 |
| <a name="module_route_table_private"></a> [route\_table\_private](#module\_route\_table\_private) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/route-table/ | tags/1.1.3 |
| <a name="module_route_table_public"></a> [route\_table\_public](#module\_route\_table\_public) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/route-table/ | tags/1.1.3 |
| <a name="module_ssh_key"></a> [ssh\_key](#module\_ssh\_key) | git::https://github.com/SkylerPark/terraform-aws-ec2-module.git//modules/key-pair/ | tags/1.2.1 |
| <a name="module_subnet_group"></a> [subnet\_group](#module\_subnet\_group) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/subnet-group/ | tags/1.1.3 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/vpc/ | tags/1.1.3 |

## Resources

| Name | Type |
|------|------|
| [aws_ami.eks_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.eks_default_arm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
