module "eip" {
  source   = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/elastic-ip/?ref=tags/1.1.3"
  for_each = toset(["parksm-natgw-ap-northeast-2a", "parksm-natgw-ap-northeast-2c"])
  name     = each.key
}
