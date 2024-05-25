locals {
  eni_config_subnets = {
    for subnet in module.subnet_group["parksm-secondary-subnet"].subnets :
    subnet.availability_zone => subnet.id...
  }
}

module "eni_config" {
  source   = "../../modules/eni-config"
  for_each = toset(["ap-northeast-2a", "ap-northeast-2c"])

  name            = each.key
  security_groups = [module.node_sg.id]
  subnet          = local.eni_config_subnets[each.key][0]
}
