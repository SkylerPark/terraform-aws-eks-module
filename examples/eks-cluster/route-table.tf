module "route_table_public" {
  source  = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/route-table/?ref=tags/1.1.3"
  name    = "parksm-public-rt"
  vpc_id  = module.vpc.id
  subnets = module.subnet_group["parksm-public-subnet"].ids

  ipv4_routes = [
    {
      destination = "0.0.0.0/0"
      target = {
        type = "INTERNET_GATEWAY"
        id   = module.vpc.internet_gateway.id
      }
    }
  ]

  propagating_vpn_gateways = []
}

module "route_table_private" {
  source   = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/route-table/?ref=tags/1.1.3"
  for_each = toset(["ap-northeast-2a", "ap-northeast-2c"])
  name     = "parksm-private-rt-${each.key}"
  vpc_id   = module.vpc.id
  subnets = [
    for subnet in module.subnet_group["parksm-private-subnet"].subnets_by_az[each.key] :
    subnet.id
  ]

  ipv4_routes = [
    {
      destination = "0.0.0.0/0"
      target = {
        type = "NAT_GATEWAY"
        id   = module.nat_gateway[each.key].id
      }
    }
  ]

  propagating_vpn_gateways = []
}
