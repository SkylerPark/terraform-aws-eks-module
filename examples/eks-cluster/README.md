# eks-cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ../../modules/cluster | n/a |
| <a name="module_cluster_kms"></a> [cluster\_kms](#module\_cluster\_kms) | git::https://github.com/SkylerPark/terraform-aws-kms-module.git//modules/key/ | tags/1.0.2 |
| <a name="module_cluster_role"></a> [cluster\_role](#module\_cluster\_role) | git::https://github.com/SkylerPark/terraform-aws-iam-module.git//modules/iam-role/ | tags/1.0.1 |
| <a name="module_control_plane_sg"></a> [control\_plane\_sg](#module\_control\_plane\_sg) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/ | tags/1.1.5 |
| <a name="module_eip"></a> [eip](#module\_eip) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/elastic-ip/ | tags/1.1.3 |
| <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/nat-gateway/ | tags/1.1.3 |
| <a name="module_node_sg"></a> [node\_sg](#module\_node\_sg) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/ | tags/1.1.5 |
| <a name="module_pod_sg"></a> [pod\_sg](#module\_pod\_sg) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/security-group/ | tags/1.1.5 |
| <a name="module_route_table_private"></a> [route\_table\_private](#module\_route\_table\_private) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/route-table/ | tags/1.1.3 |
| <a name="module_route_table_public"></a> [route\_table\_public](#module\_route\_table\_public) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/route-table/ | tags/1.1.3 |
| <a name="module_subnet_group"></a> [subnet\_group](#module\_subnet\_group) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/subnet-group/ | tags/1.1.3 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/vpc/ | tags/1.1.3 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
