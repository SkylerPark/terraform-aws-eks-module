locals {
  nat_subnets = {
    for subnet in module.subnet_group["parksm-public-subnet"].subnets :
    subnet.availability_zone => subnet.id...
  }

  nat_gateways = [
    {
      az  = "ap-northeast-2a"
      eip = "parksm-natgw-ap-northeast-2a"
    },
    {
      az  = "ap-northeast-2c"
      eip = "parksm-natgw-ap-northeast-2c"
    }
  ]
}

module "nat_gateway" {
  source = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/nat-gateway/?ref=tags/1.1.3"

  for_each = {
    for nat_gateway in local.nat_gateways :
    nat_gateway.az => nat_gateway
  }

  name      = "parksm-natgw-${each.key}"
  subnet_id = local.nat_subnets[each.key][0]
  primary_ip_assignment = {
    elastic_ip = module.eip[each.value.eip].id
  }
}
