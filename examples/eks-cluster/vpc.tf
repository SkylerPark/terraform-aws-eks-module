module "vpc" {
  source = "git::https://github.com/SkylerPark/terraform-aws-vpc-module.git//modules/vpc/?ref=tags/1.1.3"
  name   = "parksm-test"
  ipv4_cidrs = [
    {
      cidr = "10.70.0.0/16"
    }
  ]

  internet_gateway = {
    enabled = true
  }
}
